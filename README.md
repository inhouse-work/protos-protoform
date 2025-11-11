# Protoform

This is a more opinionated fork of [Superform](https://github.com/rubymonolith/superform).
Uses [protos](https://github.com/inhouse-work/protos) as base components.

Originally this library was created to experiment with Superform and has become
its own distinct flavor.

## Usage

```
gem "protos-protoform", require: "protoform"
```

Once the gem is installed you can run the generators:

```
bin/rails g protoform:install
```

This will:

- Add `phlex-rails` to your gemfile if it does not exist
- Add `layouts`, `components` and other folders to be autoloaded from `app/views`
- Add an `ApplicationForm` as the base form class to your `app/views`

This gem follows the same conventions as Superform with some key differences:

- All components inherit from `Protos::Component`

## Forms

In classic Rails you use a form builder object. Protoform is a type of form
builder built specifically for Phlex based components. Otherwise, it completely
follows the behavior of Rails forms, just with a nicer API.

- Every form takes a model that at least includes `ActiveModel::Naming` and
  `ActiveModel::Conversion`
- URLs for the form are defaulted to the current controller's `create` or
  `update` methods but can be overwritten
- Naming for IDs and names follows Rails conventions
- Collections and namespaces have a different API but work the same way

## Defining forms

At minimum your form needs to inherit from `Protoform::Rails::Form` and have a
`Field` constant inside that defines the field's API.

```ruby
class ApplicationForm < Protoform::Rails::Form
  class Field < Protoform::Field
  end
end
```

Then you can use these to subclass your own forms:

```ruby
module Posts
  class Form < ApplicationForm
    def view_template
      render field(:title).label("Title")
      render field(:title).input(required: true)

      render field(:body).label("Body")
      render field(:body).textarea(rows: 10)

      button "Submit"
    end
  end
end

render Posts::Form.new(@post)
```

Assuming our model is a `Post`, then the params would be returned under that
key.

```
{
  post: {
    title: "The title",
    body: "The body"
  }
}
```

We can change that by overriding the `#key` within our form:

```ruby
module Posts
class Form < ApplicationForm
  def key = "article"

  # ...
end
```

Now you would get:

```
{
  article: {
    title: "The title",
    body: "The body"
  }
}
```

If we wanted to customize the `#input` method or anything else we could override
it inside the `Field` constant:

```ruby
class ApplicationForm < Protoform::Rails::Form
  class Field < Protoform::Field
    # We can override the default fields with our own
    def input(...)
      Forms::Input.new(self, ...)
    end
  end

  # Here we make a simple helper to make our syntax shorter. Given a field it
  # will also render its label.
  def labeled(component)
    div class: "form-row" do
      render component.field.label
      render component
    end
  end

  def submit(text)
    button(type: :submit) { text }
  end
end
```

With the helper we created can now write our form more succinctly:

```ruby
module Posts
  class Form < ApplicationForm
    def view_template
      labeled field(:title).input(required: true)
      labeled field(:body).textarea(rows: 10)

      submit
    end
  end
end
```

In this way you can design your own form DSL that fits your application's needs.

## Namespacing and collections

The way collections work is not quite the same as Rails:

```ruby
class AccountForm < Superform::Rails::Form
  def view_template
    # Account#owner returns a single object
    namespace :owner do |owner|
      # Renders input with the name `account[owner][name]`
      owner.field(:name).text
      # Renders input with the name `account[owner][email]`
      owner.field(:email).email
    end

    # Account#members returns a collection of objects
    collection(:members).each do |member|
      # Renders input with the name `account[members][0][name]`,
      # `account[members][1][name]`, ...
      member.field(:name).input
      # Renders input with the name `account[members][0][email]`,
      # `account[members][1][email]`, ...
      member.field(:email).input(type: :email)

      # Member#permissions returns an array of values like
      # ["read", "write", "delete"].
      member.field(:permissions).collection do |permission|
        # Renders input with the name `account[members][0][permissions][]`,
        # `account[members][1][permissions][]`, ...
        render permission.label do
          plain permisson.value.humanize
          render permission.checkbox
        end
      end
    end
  end
end
```

`#collection` methods require the use of the each method to enumerate over each
item in the collection.

There's three different types of namespaces and collections to consider:

1. **Namespace** - `namespace(:field_name)` is used to map form fields to a single
   object that's a child of another object. In ActiveRecord, this could be a
   `has_one` or `belongs_to` relationship.
2. **Collection** - `collection(:field_name).each` is used to map a collection of
   objects to a form. In this case, the members of the account. In ActiveRecord,
   this could be a `has_many` relationship.
3. **Field Collection** - `field(:field_name).collection.each` is used when the
   value of a field is enumerable, like an array of values. In ActiveRecord,
   this could be an attribute that's an Array type.

## Architecture

Forms are a nested hierarchy of `Protoform::Namespace` and `Protoform::Field` objects.

```ruby
form = Protoform::Namespace.new(:post, parent: nil, object: nil) do |f|
  f.field(:title, value: "Hello World")

  f.collection(:comments) do |comments|
    comments.namespace(:comment, object: nil) do |comment|
      comment.field(:body, value: "Great post!")
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/rubymonolith/superform. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [code of
conduct](https://github.com/rubymonolith/superform/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Superform project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/rubymonolith/superform/blob/main/CODE_OF_CONDUCT.md).
