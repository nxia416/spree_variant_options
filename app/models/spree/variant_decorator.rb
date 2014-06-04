Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper

  def to_hash
    price_no_decimal = number_with_precision(self.price_in(Spree::Config[:presentation_currency]).amount, precision: 0)
    comma_seperated_price = number_with_delimiter(price_no_decimal, delimiter: ',')
    {
      :id    => self.id,
      :in_stock => self.in_stock?,
      :price => comma_seperated_price
    }
  end

end
