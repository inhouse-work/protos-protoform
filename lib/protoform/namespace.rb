# frozen_string_literal: true

module Protoform
  # A Namespace maps and object to values, but doesn't actually have a value
  # itself. For example, a `User` object or ActiveRecord model could be passed
  # into the `:user` namespace. To access the values on a Namespace, the `field`
  # can be called for single values.
  #
  # Additionally, to access namespaces within a namespace, such as if a `User
  # has_many :addresses` in ActiveRecord, the `namespace` method can be called
  # which will return another Namespace object and set the current Namespace as
  # the parent.
  class Namespace < Node
    include Enumerable

    attr_reader :object

    def initialize(key, parent:, object: nil, field_class: Field)
      super(key, parent:)
      @object = object
      @field_class = field_class
      @children = {}
      yield self if block_given?
    end

    # Creates a `Namespace` child instance with the parent set to the current
    # instance, adds to the `@children` Hash to ensure duplicate child
    # namespaces aren't created, then calls the method on the `@object` to get
    # the child object to pass into that namespace.
    #
    # For example, if a `User#permission` returns a `Permission` object, we
    # could map that to a form like this:
    #
    # ```ruby
    # Protoform :user, object: User.new do |form|
    #   form.namespace :permission do |permission|
    #     form.field :role
    #   end
    # end
    # ```
    def namespace(key, &block)
      create_child(
        key:,
        child_class: self.class,
        field_class: @field_class,
        object: object_for(key:),
        &block
      )
    end

    # Maps the `Object#proprety` and `Object#property=` to a field in a web form
    # that can be read and set by the form. For example, a User form might look
    # like this:
    #
    # ```ruby
    # Protoform :user, object: User.new do |form|
    #   form.field :email
    #   form.field :name
    # end
    # ```
    def field(key)
      create_child(
        key:,
        child_class: @field_class,
        object:
      ).tap do |field|
        yield field if block_given?
      end
    end

    # Wraps an array of objects in Namespace classes. For example, if
    # `User#addresses` returns an enumerable or array of `Address` classes:
    #
    # ```ruby
    # Protoform :user, object: User.new do |form|
    #   form.field :email
    #   form.field :name
    #   form.collection :addresses do |address|
    #     address.field(:street)
    #     address.field(:state)
    #     address.field(:zip)
    #   end
    # end
    # ```
    # The object within the block is a `Namespace` object that maps each object
    # within the enumerable to another `Namespace` or `Field`.
    def collection(key, &block)
      create_child(
        key:,
        child_class: NamespaceCollection,
        &block
      )
    end

    # Creates a Hash of Hashes and Arrays that represent the fields and
    # collections of the Protoform. This can be used to safely update
    # ActiveRecord objects without the need for Strong Parameters. You will want
    # to make sure that all the fields displayed in the form are ones that
    # you're OK updating from the generated hash.
    def serialize
      each_with_object({}) do |child, hash|
        hash[child.key] = child.serialize
      end
    end

    # Iterates through the children of the current namespace, which could be
    # `Namespace` or `Field` objects.
    def each(&block)
      @children.values.each(&block)
    end

    # Assigns a hash to the current namespace and children namespace.
    def assign(hash)
      tap do
        each do |child|
          child.assign hash[child.key]
        end
      end
    end

    # Creates a root Namespace, which is essentially a form.
    def self.root(*args, **kwargs, &block)
      new(*args, parent: nil, **kwargs, &block)
    end

    protected

    # Calls the corresponding method on the object for the `key` name, if it
    # exists. For example if the `key` is `email` on `User`, this method would
    # call `User#email` if the method is present.
    #
    # This method could be overwritten if the mapping between the `@object` and
    # `key` name is not a method call. For example, a `Hash` would be accessed
    # via `user[:email]` instead of `user.send(:email)`
    def object_for(key:)
      @object.send(key) if @object.respond_to? key
    end

    private

    # Checks if the child exists. If it does then it returns that. If it
    # doesn't, it will build the child.
    def create_child(key:, child_class:, **kwargs, &block)
      @children.fetch(key) do
        @children[key] = child_class.new(
          key,
          parent: self,
          **kwargs,
          &block
        )
      end
    end
  end
end
