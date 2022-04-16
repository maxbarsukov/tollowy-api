module SwaggerGenerator
  def self.generate_data(type, attr: nil, meta: nil)
    data = create_basic_data(type)

    if meta
      data[:properties][:data][:properties][:meta] = { type: :object, **meta }
      data[:properties][:data][:required] << 'meta'
    end

    if attr
      data[:properties][:data][:properties][:attributes] = { type: :object, **attr }
      data[:properties][:data][:required] << 'attributes'
    end
    data
  end

  def self.create_basic_data(type)
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: { type: { type: :string, enum: [type] } },
          required: %w[type]
        }
      },
      required: ['data']
    }
  end
end
