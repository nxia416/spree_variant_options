Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper

  def to_hash
    price = self.prices.find_by(currency: Spree::Config[:presentation_currency]).display_price.to_html
    {
      :id    => self.id,
      :in_stock => self.in_stock?,
      :price => price
    }
  end

end
