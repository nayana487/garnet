module TagHelper
  def tag_list membership
    content_tag(:ul, class: "tags") do
      membership.taggings.map do |tagging|
        tagging_text = "#{tagging.name} #{link_to '(x)', '#', class: 'js-remove-tagging', data: {remove_tagging_path: tagging_path(tagging)}}"
        concat(content_tag(:li, tagging_text.html_safe, class:"js-tag"))
      end
    end
  end
end
