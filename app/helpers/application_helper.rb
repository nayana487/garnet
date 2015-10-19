module ApplicationHelper
  def repo_name url
    return url[(url.rindex("/") + 1)..-1] if url.include? "/"
  end

  def breadcrumbs(group, user = nil)
    output = group.ancestors([]).sort{|a,b| a.path <=> b.path}.to_a
    output.push(group)
    output.map!{|g| (link_to g.title, user ? group_membership_path(g, user) : group_path(g))}
    if user
      output.push((link_to user.username, user_path(user)))
    end
    return output.join("_").html_safe
  end

  def membership_list(memberships)
    output = ""
    memberships.sort{|a, b| a.group.path <=> b.group.path}.each do |m|
      group = m.group
      isadmin = m.is_admin ? " (admin)" : ""
      linktext = group.path + isadmin
      output += "<li>" + (link_to linktext, group_membership_path(group, m)) + "</li>"
    end
    return output.html_safe
  end

  def group_list(groups)
    output = ""
    groups.sort{|a, b| a.path <=> b.path}.each do |group|
      output += "<li>#{link_to group.path, group_path(group)}</li>"
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

  def group_descendant_tree(group)
    output = "<li><a href='/groups/#{group.id}'>#{group.title}</a><ul>"
    group.children.each do |child|
      output += group_descendant_tree(child)
    end
    output += "</ul></li>"
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

  def color_of input
    return if !input
    if !(input.class < Numeric)
      input = average_status(input)
    end
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
    # markdown_to_html = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    # markdown_to_html.render(text).html_safe
    return text
  end

end
