require 'spec_helper'
require 'example_app_shared'

if !defined?(Sequel)
  puts "** require 'sequel' to run the specs in #{__FILE__}"
else

  DB = Sequel.sqlite # in memory db

  DB.create_table! :users do
    primary_key :id
    String :name
    Integer :rating
  end

	DB.create_table! :notes do
    primary_key :id
    String :body
    Integer :owner_id
  end

  module SequelOrmSpec

    class User < Sequel::Model
      one_to_many :notes, :key => :owner_id
    end

    class Note < Sequel::Model
      many_to_one :owner, :key => :owner_id, :class => User
    end

    # here be the specs!
    describe Sequel::Model::OrmAdapter do
      before do
        User.dataset.delete
        Note.dataset.delete
      end

      describe "the OrmAdapter class" do
        subject { Sequel::Model::OrmAdapter }

        specify "#model_classes should return all model" do
          subject.model_classes.should == [User, Note]
        end
      end

      it_should_behave_like "example app with orm_adapter" do
        let(:user_class) { User }
        let(:note_class) { Note }

        def create_model(klass, attrs = {})
          klass.create(attrs)
        end

        def reload_model(model)
          model.class[model.id]
        end
      end

    end
  end

end # if !defined?(Sequel)