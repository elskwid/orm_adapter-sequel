require 'sequel'

class Sequel::Model
  extend OrmAdapter::ToAdapter
  plugin :active_model
  plugin :subclasses

  class OrmAdapter < ::OrmAdapter::Base

    # Gets a list of the available models for this adapter
    def self.model_classes
      Sequel::Model.descendents
    end

    def initialize(klass)
      @klass = klass
    end

    # Get a list of column/property/field names
    def column_names
      klass.columns
    end

    # Get an instance by id of the model. Raises an error if a model is not found.
    # This should comply with ActiveModel#to_key API, i.e.:
    #
    #   User.to_adapter.get!(@user.to_key) == @user
    #
    # Sequel: no built in finder/filter that raises an error so one is added here
    def get!(id)
      klass[wrap_key(id)] || raise(Error, "#{klass.name} not found with #{klass.primary_key} of #{wrap_key(id)}")
    end

    # Get an instance by id of the model. Returns nil if a model is not found.
    # This should comply with ActiveModel#to_key API, i.e.:
    #
    #   User.to_adapter.get(@user.to_key) == @user
    #
    def get(id)
      klass.find(wrap_key(klass.primary_key => id))
    end

    # Find the first instance, optionally matching conditions, and specifying order
    #
    # You can call with just conditions, providing a hash
    #
    #   User.to_adapter.find_first :name => "Fred", :age => 23
    #
    # Or you can specify :order, and :conditions as keys
    #
    #   User.to_adapter.find_first :conditions => {:name => "Fred", :age => 23}
    #   User.to_adapter.find_first :order => [:age, :desc]
    #   User.to_adapter.find_first :order => :name, :conditions => {:age => 18}
    #
    # When specifying :order, it may be
    # * a single arg e.g. <tt>:order => :name</tt>
    # * a single pair with :asc, or :desc as last, e.g. <tt>:order => [:name, :desc]</tt>
    # * an array of single args or pairs (with :asc or :desc as last), e.g. <tt>:order => [[:name, :asc], [:age, :desc]]</tt>
    #
    # Sequel: #.order doesn't like an array hence the *
    def find_first(options)
      conditions, order = extract_conditions!(options)
      klass.filter(conditions_to_hash(conditions)).order(*order_clause(order)).first
    end

    # Find all models, optionally matching conditions, and specifying order
    # @see OrmAdapter::Base#find_first for how to specify order and conditions
    #
    # Sequel: #.order doesn't like an array hence the *
    def find_all(options)
      conditions, order = extract_conditions!(options)
      klass.filter(conditions_to_hash(conditions)).order(*order_clause(order)).all
    end

    # Create a model using attributes
    #
    # Sequel: no support for mass creation of associated objects so we fake it.
    #         * use a Sequel transaction
    #         * passed in key (col) names are checked against association names
    #         * an array of associated objects is created with the assoc method
    #         * the main object is created followed by all associated records
    #         * save is called to throw an error if found
    #
    def create!(attributes)
      associated_objects = []
      attrs = {}

      klass.db.transaction do
        attributes.each do |col, value|
          if klass.associations.include?(col)
            Array(value).each{|v| associated_objects << [association_method(col), v]}
          else
            attrs.merge!(col => value) # pass it on
          end
        end

        obj = klass.create(attrs) # create main obj
        associated_objects.each do |m,o|
          obj.send(m, o)
        end
        obj.save
      end # transaction
    end

    protected

      def conditions_to_hash(conditions)
        conditions.inject({}) do |cond_hash, (col, value)|
          # make sure the key is a symbol
          col = col.to_sym

          if value.is_a?(Sequel::Model)
            # look up the column name for the assoc
            key = klass.association_reflection(col)[:key]
            cond_hash.merge(key => value.id)
          else
            cond_hash.merge(col => value)
          end
        end
      end

      def order_clause(order)
        m = order.map {|pair| pair.first.send(pair.last)}
        m.empty? ? nil : m
      end

      def association_method(col)
        assoc = klass.association_reflection(col)
        case assoc[:type]
        when :one_to_many, :many_to_many
          assoc.add_method
        else # when :many_to_one, :one_to_one
          assoc.setter_method
        end
      end
  end

end
