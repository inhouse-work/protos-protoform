# frozen_string_literal: true

RSpec.describe Protoform::DOM do
  def build_lineage(**lineage)
    lineage.reduce(nil) do |parent, (key, klass)|
      if klass.is_a?(Class) && klass.to_s == "Protoform::FieldCollection"
        klass.new(field: parent).field
      elsif klass.is_a?(Class) && klass.to_s == "Protoform::NamespaceCollection"
        klass.new(key, parent:, field_class: Protoform::Field)
      elsif klass.is_a?(Class)
        klass.new(key, parent:)
      else
        klass
      end
    end
  end

  describe "#name" do
    it "returns the name of the field when parent is nil" do
      field = build_lineage(foo: Protoform::Field)
      expect(field.dom.name).to eq("foo")
    end

    it "returns the combined name with the parent namespace" do
      field = build_lineage(parent: Protoform::Namespace, child: Protoform::Field)
      expect(field.dom.name).to eq("parent[child]")
    end

    it "returns the parent namespace when the parent is a field" do
      field = build_lineage(parent: Protoform::Field, child: Protoform::Field)
      expect(field.dom.name).to eq("parent[]")
    end

    it "returns the combined name with the parent namespace when the parent is a namespace collection" do
      field = build_lineage(
        grandparent: Protoform::Namespace.new(
          "grandparent",
          parent: nil,
          object: double("Collection", parent: nil)
        ),
        parent: Protoform::Field,
        child: Protoform::FieldCollection
      )

      expect(field.dom.name).to eq("grandparent[parent][]")
    end
  end

  describe "#id" do
    it "returns the id of the field when parent is nil" do
      field = build_lineage(foo: Protoform::Field)
      expect(field.dom.id).to eq("foo")
    end

    it "returns the combined id with the parent" do
      field = build_lineage(parent: Protoform::Namespace, child: Protoform::Field)
      expect(field.dom.id).to eq("parent_child")
    end

    it "returns the combined id when the parent is a namespace" do
      field = build_lineage(parent: Protoform::Field, child: Protoform::Field)
      expect(field.dom.id).to eq("parent_child")
    end

    it "returns the combined id when the parent is a collection" do
      field = build_lineage(
        grandparent: Protoform::Namespace.new(
          "grandparent",
          parent: nil,
          object: double("Collection", bars: [{ baz: "A" }])
        ),
        bars: Protoform::NamespaceCollection,
        baz: Protoform::Field
      )

      expect(field.dom.id).to eq("grandparent_bars_baz")
    end
  end
end
