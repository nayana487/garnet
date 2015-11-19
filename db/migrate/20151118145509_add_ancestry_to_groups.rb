class AddAncestryToGroups < ActiveRecord::Migration

  def group_ancestors(group, collection = [])
    parent_id = group.read_attribute(:parent_id)
    if parent_id
      parent = Group.find(parent_id)
      collection.unshift(parent)
      collection = group_ancestors(parent, collection)
    end
    return collection
  end

  def change
    add_column :groups, :ancestry, :string
    add_index :groups, :ancestry
    Group.all.each do |group|
      ancestor_ids = group_ancestors(group).collect(&:id)
      if ancestor_ids.any?
        ancestry_string = ancestor_ids.join("/")
        group.update!(ancestry: ancestry_string)
      end
    end
    # remove_column :groups, :parent_id, :integer
  end

end
