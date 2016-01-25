class TaggingsController < ApplicationController
  def create
    # Rails includes a blank option on multi-select boxes to ensure param is
    # passed to controller even if nothing is selected
    # we don't care about this, so we remove those blank entries
    membership_ids = params[:membership_ids].reject(&:blank?)
    tag_params = params[:tag_ids].reject(&:blank?)

    failed_taggings = []
    # Because select2 allows new entries for tags, those entries will be the
    # name of the tag instead of the id. e.g. tag_ids could look like: [1,4, "new tag"]
    tag_params.each do |tag_param|
      if is_id(tag_param) # if the tag is an int, it's a tag id
        tag = Tag.find(tag_param)
      else # it not, treat it as a new tag name for this cohort
        tag = Tag.find_or_create_by(name: tag_param) # but if the tag exists globally, reuse it
      end

      membership_ids.each do |member_id|
        new_tagging = Tagging.new(membership_id: member_id, tag: tag)
        if new_tagging.save
          # do nothing
        else
          membership = Membership.find(member_id)
          failed_taggings << "tag '#{tag.name}' for #{membership.name}"
        end
      end
    end

    if failed_taggings.any?
      redirect_to :back, notice: "Some tags failed to add: " + failed_taggings.to_sentence
    else
      redirect_to :back, notice: "All tags successfully added."
    end
  end

  private
  def is_id(string)
    string.to_i.to_s == string && string.to_i > 0
  end

end
