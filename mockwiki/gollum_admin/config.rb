# ~*~ encoding: utf-8 ~*~

# Github says to "always include this"
Gollum::Page.send :remove_const, :FORMAT_NAMES if defined? Gollum::Page::FORMAT_NAMES

# TODO: change this to gitlab-lib + gollum version ????
# grab the gollum version for later conditionals
gollum_lib_version = Gem.loaded_specs["gollum-lib"].version.version
puts "** Gollum config.rb using configuration for Gollem version: #{gollum_lib_version} **"
STDOUT.flush

if ( Gem.loaded_specs['gollum-lib'].version <= Gem::Version.create('4.2.7') )
  # Monkey patch find_sub_pages()
  # * Purpose: Applies patch for gollum-lib issue #1161 (Fix rendering of TOC on the sidebar)
  # * Works for gollum-lib 4.2.7 (from Gollum 4.1.1 release)
  # * Reference file: gollum-lib/pages.rb (gollum-lib: v4.2.7) / gollum v4.1.2
  module Gollum
    class Page
      def find_sub_pages(subpagenames = SUBPAGENAMES, map = nil)
        subpagenames.each{|subpagename| instance_variable_set("@#{subpagename}", nil)}
        return nil if self.filename =~ /^_/ || ! self.version

        map ||= @wiki.tree_map_for(@wiki.ref, true)
        valid_names = subpagenames.map(&:capitalize).join("|")
        # From Ruby 2.2 onwards map.select! could be used
        map = map.select{|entry| entry.name =~ /^_(#{valid_names})/ }
        return if map.empty?

        subpagenames.each do |subpagename|
          dir = ::Pathname.new(self.path)
          while dir = dir.parent do
            subpageblob = map.find do |blob_entry|

              filename = "_#{subpagename.to_s.capitalize}"
              searchpath = dir == Pathname.new('.') ? Pathname.new(filename) : dir + filename
              entrypath = ::Pathname.new(blob_entry.path)
              # Ignore extentions
              entrypath = entrypath.dirname + entrypath.basename(entrypath.extname)
              entrypath == searchpath
            end

            if subpageblob
              #instance_variable_set("@#{subpagename}", subpageblob.page(@wiki, @version) )
              subpage =  subpageblob.page(@wiki, @version)
              subpage.parent_page = self
              instance_variable_set("@#{subpagename}", subpage)
              break
            end

            break if dir == Pathname.new('.')
          end
        end
      end
    end
  end
end

############
# Attempt to override Gollum::Git.grep
# original file: /var/lib/gems/2.1.0/gems/gollum-grit_adapter-1.0.1/lib/grit_adapter/git_layer_grit.rb
#
# We are overriding Gollum::Git::Git.grep in order to open up the native 'git grep' regex capabilities.

module Gollum
  module Git
    # Note that in Grit, the methods grep, rm, checkout, ls_files
    # are all passed to native via method_missing. Hence the uniform
    # method signatures.
    class Git
      def grep(query, options={})
        ref = options[:ref] ? options[:ref] : "HEAD"

        ##########################
        # # Comment out Shellwords stuffs:
        # * Shellwords seemed to be causing an issue with the end result of the query.
        # * I haven't yet investigated why Shellwords was causing a problem.
        #
        # * NOTE: !!! POSSIBLE SECURITY RISK !!!
        #     * I haven't tested for injections to the 'git grep' native command at all!
        # ------------------------
        # query = Shellwords.shellescape(query)
        # query = Shellwords.split(query).select {|q| !(q =~ /^(-O)|(--open-files-in-pager)/) }
        # query = Shellwords.join(query)
        # args = [{}, '-I', '-i', '-c', query, ref, '--']
        ##########################

        ##########################
        # # Replace the query escapes and build args:
        # * Just split the query string on spaces.
        # * TODO:
        #     * [ ] spaces now need to be escaped if they are used in groupings
        query = query.split(" ")

        # * Add --all-match and --extended-regexp to the arguments list plus the now delimited query
        # * The array format is <empty hash> +  <git grep options> + <query> + <branch reference (i.e. HEAD) + <end of options specifier>
        args = [{}, '--all-match', '-I', '-i', '-c', '--extended-regexp']+query+[ref, '--']
        #args = [{}, '--all-match -I -i -c --extended-regexp gollum HEAD -- testfiles']
        ##########################


        ##########################
        # The rest of the original code

        args << options[:path] if options[:path]
        result = @git.native(:grep, *args).split("\n")
        result.map do |line|
          branch_and_name, _, count = line.rpartition(":")
          branch, _, name = branch_and_name.partition(':')
          {:name => name, :count => count}
        ##########################
        end
      end
    end
  end
end

##### Unfortunately, we can't do this. It causes an error for file edits -to be debugged some other time
# # Remove all markdown formats so we can limit gollum to .vimwiki only
# Gollum::Markup.formats.clear
# # and then define the sole markup to be supported:
# Gollum::Markup.formats[:vimwiki] = {
#     :name => "Vimwiki",
#     :regexp => /vimwiki/
# }

##########################
# # Custom extension + processor for '.vimwiki' files:
# ## Explanation:
# * Honestly, I couldn't figure out how to just add Gollum's Markup processor for a custom extension so I ended up doing this.
# ## References
# * file reference: /var/lib/gems/2.1.0/gems/github-markup-1.6.0/lib/github/markup/command_implementation.rb
# * [Adding Pandoc to Gollum - Martin Wolf's weblog [OUTDATED]](https://www.mwolf.net/2014/04/29/adding-pandoc-to-gollum/)
ci = ::GitHub::Markup::CommandImplementation.new(
    /vimwiki/,
    ["Vimwiki"],
    #"pandoc -f markdown-tex_math_dollars-raw_tex",                               # works but I would like to use internal
    "pandoc -f markdown_github",                                                  # Best fit so far
    #::GitHub::Markup::Markdown.new,                                              # doesn't work at all
    #::GitHub::Markup::markup_impl(":vimwiki", ::GitHub::Markup::Markdown.new),   # sortof works. I'm still missing something
    :vimwiki)

# tell the Markup initializer that :vimwiki types of files will use the implementation spec. from the previous section
#
## doesn't work (even after registering with gollum)
#GitHub::Markup::markup_impl(:vimwiki, ::GitHub::Markup::Markdown.new)
#
# works
GitHub::Markup::markup_impl(:vimwiki, ci)

# # Register the new extension with gollum-lib
# * file reference: gollum-lib/markup.rb
#
# register the new primary extension (:vimwiki) with a markdown type name (Vimwiki)
case gollum_lib_version
when "4.2.7"
  Gollum::Markup.register(:vimwiki,  "Vimwiki", :regex => /vimwiki/, :reverse_links => true)
when "5.0.a.3"
  Gollum::Markup.register(:vimwiki,  "Vimwiki", :enabled => Gollum::MarkupRegisterUtils::executable_exists?("pandoc"), :extensions => ["vimwiki"], :reverse_links => true)
  puts "** Gollum config.rb: Vimwiki extension registration using gollum-lib version: 5.0.a.3. WARNING: relative links are broken in this version **"
  STDOUT.flush
else
  ## default to 4.2.7 (for now) -change as compatability changes
  Gollum::Markup.register(:vimwiki,  "Vimwiki", :regex => /vimwiki/, :reverse_links => true)
  puts "** Gollum config.rb: Vimwiki extension registration reverting to gollum-lib version: 4.2.7 **"
  STDOUT.flush
end
##################

# fix a regex bug in mediawiki that caused vimwiki not to be recognized for edits
# Note: the placement of this matters -needs to be after vimwiki stuff for edit to show up correctly
# This is fixed in gollum-lib v5.0.a.3

case gollum_lib_version
when "4.2.7"
  Gollum::Markup.formats.delete(:mediawiki)
  Gollum::Markup.register(:mediawiki, "MediaWiki", :regexp => /mediawiki|wiki/, :reverse_links => true)
#when "4.1.X"     # for future or past versions
end

##################
# # Set the default gollum index (landing page) page name
# * NOTE: This is **REUIRED** for Vimwiki integration so that Gollum will find the individual Vimwiki index pages by default.
# * Note: Having landing pages default to 'index.vimwiki' does not fix Vimwiki diary index issues due to Vimwiki formatting.
Precious::App.set(:wiki_options, index_page: "index")

##################
# # My preferred global options -I use the sidebar:
# * turn on/off TOC for all pages (unless specified by macro in the markdown file)
Precious::App.set(:wiki_options, { :universal_toc => false })

# This doesn't work here for whatever reason... using command line anyway. (v4.1.1)
# Gollum::Filter::PlantUML.configure do |config|
#   config.test = true # Skip server checks
#   config.url  = "http://localhost:8989/plantuml/png" # Non existent server
# end

##################
