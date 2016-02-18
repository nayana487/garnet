module ModelHelpers

  def class_from_string klass
    return klass.to_s.classify.constantize
  end

  def class_plural_name klass
    return klass.to_s.downcase.underscore.pluralize
  end

end
