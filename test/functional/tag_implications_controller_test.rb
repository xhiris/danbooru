require 'test_helper'

class TagImplicationsControllerTest < ActionController::TestCase
  context "The tag implications controller" do
    setup do
      @user = FactoryGirl.create(:admin_user)
      CurrentUser.user = @user
      CurrentUser.ip_addr = "127.0.0.1"
      MEMCACHE.flush_all
      Delayed::Worker.delay_jobs = false
    end

    teardown do
      CurrentUser.user = nil
      CurrentUser.ip_addr = nil
    end


    context "edit action" do
      setup do
        @tag_implication = FactoryGirl.create(:tag_implication, :antecedent_name => "aaa", :consequent_name => "bbb")
      end

      should "render" do
        get :edit, {:id => @tag_implication.id}
        assert_response :success
      end
    end

    context "update action" do
      setup do
        @tag_implication = FactoryGirl.create(:tag_implication, :antecedent_name => "aaa", :consequent_name => "bbb")
      end

      context "for a pending implication" do
        setup do
          @tag_implication.update_attribute(:status, "pending")
        end

        should "succeed" do
          post :update, {:id => @tag_implication.id, :tag_implication => {:antecedent_name => "xxx"}}, {:user_id => @user.id}
          @tag_implication.reload
          assert_equal("xxx", @tag_implication.antecedent_name)
        end
      end

      context "for an approved implication" do
        setup do
          @tag_implication.update_attribute(:status, "approved")
        end

        should "fail" do
          post :update, {:id => @tag_implication.id, :tag_implication => {:antecedent_name => "xxx"}}, {:user_id => @user.id}
          @tag_implication.reload
          assert_equal("aaa", @tag_implication.antecedent_name)
        end
      end
    end

    context "index action" do
      setup do
        CurrentUser.scoped(@user, "127.0.0.1") do
          @tag_implication = FactoryGirl.create(:tag_implication, :antecedent_name => "aaa", :consequent_name => "bbb")
        end
      end

      should "list all tag implications" do
        get :index
        assert_response :success
      end

      should "list all tag_implications (with search)" do
        get :index, {:search => {:antecedent_name => "aaa"}}
        assert_response :success
      end
    end

    context "destroy action" do
      setup do
        CurrentUser.scoped(@user, "127.0.0.1") do
          @tag_implication = FactoryGirl.create(:tag_implication)
        end
      end

      should "destroy a tag_implication" do
        assert_difference("TagImplication.count", -1) do
          post :destroy, {:id => @tag_implication.id}, {:user_id => @user.id}
        end
      end
    end
  end
end
