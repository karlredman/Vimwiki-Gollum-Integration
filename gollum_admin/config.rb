# # always include this:
Gollum::Page.send :remove_const, :FORMAT_NAMES if defined? Gollum::Page::FORMAT_NAMES

#################### custom extension + processor
## # Rendering
## ## References
## * file reference: /var/lib/gems/2.1.0/gems/github-markup-1.6.0/lib/github/markup/command_implementation.rb
## * [Adding Pandoc to Gollum - Martin Wolf's weblog [OUTDATED]](https://www.mwolf.net/2014/04/29/adding-pandoc-to-gollum/)
#ci = ::GitHub::Markup::CommandImplementation.new(
#     /vimwiki/,
#     ["Vimwiki"],
#     "pandoc -f markdown-tex_math_dollars-raw_tex",
#     #::GitHub::Markup::Markdown.new,
#     :vimwiki)

## bind your own extension regex (the new set of extensions will also include `.asc` and `.adoc`):
## # * file reference: /var/lib/gems/2.1.0/gems/github-markup-1.6.0/lib/github/markups.rb
#Gollum::Markup.register(:vimwiki,  "Vimwiki")
#Gollum::Markup.formats[:vimwiki][:regexp] = /vimwiki/
#GitHub::Markup::markup_impl(:vimwiki, ci)
###################

# Attempt to replace the primary extension for Markdown
# remove the original markdown binding:
Gollum::Markup.formats.delete(:markdown)

# and define your own 
Gollum::Markup.formats[:thing] = {
    :name => "Markdown",
    :regexp => /markdown/
}

# Gollum::Markup.formats[:markdown][:regexp] = /(?:markdown|md|vimwiki|thing)/

# #Gollum::Markup.formats.delete(:markdown)
# GitHub::Markup.markup(:thing, :github_markup, /vimwiki|thing/, ["Thing"]) do |content|
# 	GitHub::Markdown.render(content)
# 	#Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(content)
# 	#Kramdown::Document.new(content).to_html
# end


############### global options
## set the default index page name 
#Precious::App.set(:wiki_options, index_page: "index")

## turn on TOC for all pages
#Precious::App.set(:wiki_options, { :universal_toc => true })
##############
