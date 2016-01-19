module ApplicationHelper

  def avatar user
    if user.image_url && !user.image_url.strip.blank?
      return link_to image_tag(user.image_url), user_path(user), class: :avatar
    end
  end

  def average_status collection
    if collection.count > 0
     return (collection.inject(0){|sum, i| sum + (i.status || 0)}.to_f / collection.count).round(2)
   else
     return 0
   end
  end

  def color_of_percent input
    case input
    when 0...25
      return "s0"
    when 25...50
      return "s1"
    when 50...75
      return "s2"
    when 75..100
      return "s3"
    end
  end

  def color_of_status input
    case input * 100
    when 0...50
      return "s0"
    when 50...100
      return "s1"
    when 100...150
      return "s2"
    when 150..200
      return "s3"
    end
  end

  def percent_of collection, value
    divisor = collection.select{|i| i.status == value}
    divisor = divisor.length
    if divisor <= 0
      percent = 0
    else
      percent = (divisor.to_f / collection.length).round(2)
    end
    return (percent * 100).to_i
  end

  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true
    }
    if text.blank?
      nil
    else
      renderer = Redcarpet::Render::HTML.new(options)
      markdown = Redcarpet::Markdown.new(renderer, extensions)
      "<div class='markdown'>#{markdown.render(text)}</div>".html_safe
    end
  end

  def status_button record, status
    output = ""
    id = "a#{record.id}_#{status}"
    checked = "checked" if record.status == status
    output += "<input type='radio' name='a#{record.id}' id='#{id}' value='#{status}' #{checked} data-record-url='#{url_for record}' data-record-attribute='status' />"
    output += "<label for='#{id}' class='status'>#{record.class.statuses[status]}</label>"
    return output.html_safe
  end

  def cohort_status(cohort, user)
    user.memberships.find_by(cohort: cohort).status.to_s
  end

end
