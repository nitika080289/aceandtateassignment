class OrderPayloadValidator
  include ActiveModel::Validations
  attr_accessor :id, :shipping_country, :lines

  validates :id, presence: true, numericality: { only_integer: true }
  validates :shipping_country, presence: true
  validate :validate_lines

  def initialize(params = {})
    @id = params[:id]
    @shipping_country = params[:shipping_country]
    @lines = params[:lines] || []
  end

  def validate_lines
    order_line = @lines.first

    if order_line["sku"].blank?
      errors.add :lines, "Sku must be present"
    end
    validate_prescription(order_line["prescription"])
  end

  def validate_prescription(prescription)

    return errors.add :prescription, "must be present" unless prescription

    unless %w[single_vision multifocal].include?(prescription["type"])
      return errors.add :prescription, "type invalid"
    end

    %w[left right].each do |eye|
      sph = prescription.dig(eye, "SPH")
      unless sph.is_a?(Numeric)
        return errors.add :sph, "Invalid SPH value"
      end
    end
  end
end
