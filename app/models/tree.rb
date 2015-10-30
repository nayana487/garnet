class Tree < ActiveRecord::Base
  self.abstract_class = true
  before_destroy :destroy_descendants

  def ancestors(collection = nil)
    collection = collection || [self]
    if self.parent
      self.parent.reload
      collection.unshift(self.parent)
      self.parent.ancestors(collection)
    end
    return collection
  end

  def descendants(collection = nil)
    collection = collection || [self]
    self.children.each do |child|
      collection.push(child)
      child.descendants(collection)
    end
    return collection
  end

  def descendant_tree
    tree = self.as_json
    children = []
    self.children.each do |child|
      children.push(child.descendant_tree)
    end
    tree[:children] = children
    return tree
  end

  def ancestors_attr attribute_name
    collection = []
    self.ancestors.each do |ancestor|
      collection.concat(ancestor.send(attribute_name))
    end
    return collection.reverse
  end

  # gathers unique list of items from current group and descendants
  # collection_method_name: can be any collection method; observations, assignments, submissions, etc.
  def descendants_attr attribute_name
    collection = Set.new(self.send(attribute_name)) # Set implements a collection of unordered values with no duplicates.
    self.descendants.each do |descendant|
      collection.merge(descendant.send(attribute_name))
    end
    return collection
  end

  def is_descendant? ancestor
    return true if self.id == ancestor.id
    while self.parent
      if self.parent.id == ancestor.id
        return true
      else
        return false
      end
    end
  end

  def create_descendants hash, name
    hash.each do |key, subtree|
      child = self.children.new
      child.send("#{name}=", key)
      child.save!
      child.create_descendants(subtree, name)
    end
  end

  def destroy_descendants
    self.class.destroy_all(parent_id: self.id)
  end

end
