# require 'rails_helper'
#
# RSpec.describe Group do
#   before(:all) do
#     load "#{Rails.root}/db/seeds/test_seed.rb"
#   end
#
#   let(:ga_root_group) { Group.at_path("ga") }
#
#   describe "path" do
#     it "is joining of ancestor group titles with underscore" do
#       expect(Group.find_by(title: "squad-adam").path_string).to eq("ga_wdi_dc_7_squad-adam")
#     end
#     context "on updating of ancestor's title" do
#       it "is also updated" do
#         newtitle = "foo"
#         Group.find_by(title: "wdi").update(title: newtitle)
#         expect(Group.find_by(title: "squad-adam").path_string).to eq("ga_foo_dc_7_squad-adam")
#       end
#     end
#   end
#
#   describe "membership methods" do
<<<<<<< HEAD
#     describe "#owners" do
#       it "includes users with physical memberships in the group where #is_owner is true" do
#         owners = Group.at_path("ga_wdi_dc_7_squad-adam").owners
#         expect(owners).to match_array([User.named("adam")])
#       end
#     end
#
#     describe "#nonowners" do
#       it "includes users with physical memberships in the group where #is_owner is not true" do
#         nonowners = Group.at_path("ga_wdi_dc_7_squad-adam").nonowners
#         expect(nonowners).to match_array([User.named("jane"), User.named("john"), User.named("testwdidcstudent")])
=======
#     describe "#admins" do
#       it "includes users with physical memberships in the group where #is_admin is true" do
#         admins = Group.at_path("ga_wdi_dc_7_squad-adam").admins
#         expect(admins).to match_array([User.named("adam")])
#       end
#     end
#
#     describe "#nonadmins" do
#       it "includes users with physical memberships in the group where #is_admin is not true" do
#         nonadmins = Group.at_path("ga_wdi_dc_7_squad-adam").nonadmins
#         expect(nonadmins).to match_array([User.named("jane"), User.named("john"), User.named("testwdidcstudent")])
>>>>>>> misc_fixes_and_cleanup
#       end
#     end
#
#     describe "#admins" do
#       before(:all) do
#         @admins = Group.at_path("ga_wdi_dc_7_squad-adam").admins
#       end
<<<<<<< HEAD
#       it "includes users who are owners of the group" do
#         expect(@admins).to include(User.named("adam"))
#       end
#       it "trickle down: includes owners of any ancestor groups" do
#         expect(@admins).to include(User.named("jesse"))
#       end
#       it "does not include users who are nonowners of the group" do
#         expect(@admins).to_not include(User.named("john"))
#       end
#       describe "membership abilities" do
#         it "can change an owner's membership status to nonowner"
#         it "can remove an nonowner's membership from group"
=======
#       it "includes users who are admins of the group" do
#         expect(@admins).to include(User.named("adam"))
#       end
#       it "trickle down: includes admins of any ancestor groups" do
#         expect(@admins).to include(User.named("jesse"))
#       end
#       it "does not include users who are nonadmins of the group" do
#         expect(@admins).to_not include(User.named("john"))
#       end
#       describe "membership abilities" do
#         it "can change an admin's membership status to nonadmin"
#         it "can remove an nonadmin's membership from group"
>>>>>>> misc_fixes_and_cleanup
#       end
#     end
#
#     describe "#nonadmins" do
#       subject(:nonadmins) { Group.at_path("ga_wdi_dc_7").nonadmins }
#       let(:test_leader) { User.create!(username: "test_leader", password: "foo") }
#       let!(:test_squad) do
#         squad = Group.at_path("ga_wdi_dc_7").children.create!(title: "TEST-SQUAD")
<<<<<<< HEAD
#         squad.add_owner(test_leader, true)
#       end
#
#       it "includes users who are nonowners of the group" do
=======
#         squad.add_admin(test_leader, true)
#       end
#
#       it "includes users who are nonadmins of the group" do
>>>>>>> misc_fixes_and_cleanup
#         expect(nonadmins).to include(User.named("alice"))
#       end
#
#       describe "bubble up" do
<<<<<<< HEAD
#         it "includes nonowners of any descendant groups" do
#           expect(nonadmins).to include(User.named("john"))
#         end
#         it "includes owners of any descendant groups" do
=======
#         it "includes nonadmins of any descendant groups" do
#           expect(nonadmins).to include(User.named("john"))
#         end
#         it "includes admins of any descendant groups" do
>>>>>>> misc_fixes_and_cleanup
#           expect(nonadmins).to include(User.named("test_leader"))
#         end
#       end
#
<<<<<<< HEAD
#       it "does not include users who are owners of the group" do
=======
#       it "does not include users who are admins of the group" do
>>>>>>> misc_fixes_and_cleanup
#         expect(nonadmins).to_not include(User.named("jesse"))
#         expect(nonadmins).to_not include(User.named("adam"))
#       end
#     end
#
<<<<<<< HEAD
#     describe "#add_owner" do
#
#       let(:test_owner) { User.create!(username: "test_owner", password: "password") }
=======
#     describe "#add_admin" do
#
#       let(:test_admin) { User.create!(username: "test_admin", password: "password") }
>>>>>>> misc_fixes_and_cleanup
#
#       describe "(defaults)" do
#         it "is_priority as false" do
#           non_priority_group = ga_root_group.children.create(title: "TESTPRIORITY")
<<<<<<< HEAD
#           non_priority_group.add_owner(test_owner)
#           expect(test_owner.priority_groups).to be_empty
=======
#           non_priority_group.add_admin(test_admin)
#           expect(test_admin.priority_groups).to be_empty
>>>>>>> misc_fixes_and_cleanup
#         end
#       end
#
#       it "accepts, and assigns, is_priority" do
#         priority_group = ga_root_group.children.create(title: "TESTPRIORITY")
<<<<<<< HEAD
#         priority_group.add_owner(test_owner, true)
#         expect(test_owner.priority_groups).to include(priority_group)
=======
#         priority_group.add_admin(test_admin, true)
#         expect(test_admin.priority_groups).to include(priority_group)
>>>>>>> misc_fixes_and_cleanup
#       end
#     end
#   end
#
#   context "on destroy" do
#     before(:all) do
#       Group.at_path("ga").destroy!
#     end
#     it "also destroys all descendants" do
#       expect(Group.all.count).to eq(0)
#     end
#     it "does not also destroy descendants' attached has_manys" do
#       expect(Assignment.all.count).not_to eq(0)
#     end
#   end
# end
