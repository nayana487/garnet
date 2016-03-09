module ApplicationHelper

  # returns an array to be passed to a Rails fragment `cache` method call.
  # designed to work with a cohort and one of it's associations, such as
  # assignments, events, etc.
  #
  # the final values, `opt` can be anything, but are usually used for an option
  # related to the current user, such as whether or not they are an admin,
  # or possible the user object itself.
  def cache_key_for_cohort(cohort, association, *opt)
    return ["cohort-#{cohort.id}/events", association.maximum(:updated_at), *opt]
  end

  def avatar user, cssClass = "avatar"
    if user.image_url && !user.image_url.strip.blank?
      return link_to image_tag(user.image_url), user_path(user), class: cssClass
    end
  end

  def color_of input, options = {}
    # These are options that can optionally be passed in when the method is called
    greenest_possible_input = options[:green]
    reddest_possible_input  = options[:red]
    type_of_output          = options[:type]
    # HSL is a color method like RGB and CMYK. It stands for "Hue, Saturation, Lightness"
    # If h is 120 it's green; 240 is blue; 360 and 0 are red
    hsl_green_value = 120
    hsl_red_value   = 0
    if input.is_a? Numeric
      greenest_possible_input  ||= 100
      reddest_possible_input   ||= 0
    else # elsif input is a record, like submission, attendance, observation, etc
      greenest_possible_input  ||= (input.class.statuses.count - 1)
      reddest_possible_input   ||= 1
      input = input.read_attribute("status")
      input = nil if (input == 0)
    end
    return "" if (input.nil?)
    input_range = (greenest_possible_input - reddest_possible_input)
    input_as_percentage = (input - reddest_possible_input).to_f / (input_range)
    # How "green" is the input?
    hsl_color_value = hsl_green_value * input_as_percentage
    if hsl_color_value > hsl_green_value
      hsl_color_value = [hsl_color_value, hsl_green_value].min
    else # Makes sure the color doesn't go past green or red
      hsl_color_value = [hsl_color_value, hsl_red_value].max
    end
    hsl_string = "hsl(#{hsl_color_value},100%,90%)"
    return hsl_color_value if (type_of_output === "int")
    return hsl_string if (type_of_output === "hsl_string")
    return "style='background-color:#{hsl_string};'".html_safe
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

  def cohort_status(cohort, user)
    user.memberships.find_by(cohort: cohort).status.to_s
  end

end
