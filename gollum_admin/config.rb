# # always include this:
# ::Gollum::Page.send :remove_const, :FORMAT_NAMES if defined? Gollum::Page::FORMAT_NAMES


# # register a new extention format
# ::Gollum::Markup.formats[:vimwiki] = {
#     :name => "VimWiki",
#     :regexp => /vimwiki/
# }

# #########################
# # # Rendering
# # ## References
# # * file reference: /var/lib/gems/2.1.0/gems/github-markup-1.6.0/lib/github/markup/command_implementation.rb
# # * [Adding Pandoc to Gollum - Martin Wolf's weblog [OUTDATED]](https://www.mwolf.net/2014/04/29/adding-pandoc-to-gollum/)
ci = ::GitHub::Markup::CommandImplementation.new(
      /vimwiki/,
      ["VimWiki"],
      "pandoc -f markdown-tex_math_dollars-raw_tex",
      #::GitHub::Markup::Markdown.new,
      :vimwiki)

# # * file reference: /var/lib/gems/2.1.0/gems/github-markup-1.6.0/lib/github/markups.rb
# ::GitHub::Markup::markup_impl(:vimwiki, ci)

# always include this:
Gollum::Page.send :remove_const, :FORMAT_NAMES if defined? Gollum::Page::FORMAT_NAMES

# bind your own extension regex (the new set of extensions will also include `.asc` and `.adoc`):
Gollum::Markup.register(:vimwiki,  "VimWiki")
Gollum::Markup.formats[:vimwiki][:regexp] = /(?:vimwiki)/
GitHub::Markup::markup_impl(:vimwiki, ci)

# set the default index page name (TODO: not working yet)
#Gollum::Wiki.index_page
Precious::App.set(:wiki_options, index_page: "index")
