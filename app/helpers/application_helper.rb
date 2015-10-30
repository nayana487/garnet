module ApplicationHelper

  def breadcrumbs(group, user = nil)
    output = group.ancestors([]).sort{|a,b| a.path <=> b.path}.to_a
    output.push(group)
    output.map!{|g| (link_to g.title, group_path(g), class: "breadcrumb")}
    output = output.join("_")
    if user
      output += ("<a>admin</a>") if group.has_admin?(user)
      if user == current_user
        output += (link_to "squad", group_membership_path(group, user), method: :put, class: (group.has_priority?(user) ? "yes" : "no"))
      else
        output += ("<a>squad</a>")
      end
    end
    return output.html_safe
  end

  def group_descendant_list(group)
    output = ""
    group.descendants.each do |subgroup|
      output += "<li>" + link_to(subgroup.path, group_path(subgroup)) + "</li>"
    end
    return output.html_safe
  end

  def avatar user
    if user.image_url
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

  def is_admin_of_anything? user
    return (user.memberships.select{|m| m.is_admin?}.count > 0)
  end

  def status_buttons record
    output = ""
    record.class.statuses.each do |i, status|
      id = "a#{record.id}_#{i}"
      checked = "checked" if record.status == i
      output += "<td><input type='radio' name='a#{record.id}' id='#{id}' value='#{i}' #{checked} data-record-url='#{url_for record}' />"
      output += "<label for='#{id}'>#{status}</label></td>"
    end
    return output.html_safe
  end

  def td_averages user
    output = ""
    attendances_present = percent_of(user.attendances, 2)
    submissions_complete = percent_of(user.submissions, 2)
    observation_average = average_status(user.observations)
    output += "<td class='#{color_of_percent(attendances_present)}'>#{attendances_present}%</td>"
    output += "<td class='#{color_of_percent(submissions_complete)}'>#{submissions_complete}%</td>"
    output += "<td class='#{color_of_status(observation_average)}'>#{observation_average}</td>"
    return output.html_safe
  end

end
