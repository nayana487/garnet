module TagHelper
  def tag_list membership
    content_tag(:ul, class: "pills") do
      membership.tags.map do |tag|
        concat(content_tag(:li, link_to(tag.name, "#", class: "tag-filter")))
      end
    end
  end
end
