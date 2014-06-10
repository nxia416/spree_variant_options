window.variantOptions = (params) ->
  options = params['options']
  outOfStockStr = "[품절]"

  # select a variant option
  $(document).on "change", ".variant-option-values", ->
    parent = $(@).parents('.variant-options')
    optionId = $(@).parents(".variant-options").attr("id").split("_")[2]
    optionIndex = $(@).parents(".variant-options").data("index")

    # reset "out of stock" text
    unless $(@).find("option:selected").hasClass("in-stock")
      $(".option-value").each ->
        $(@).text($(@).text().replace("#{outOfStockStr} ", ""))

    # if this is the "select an option" option, don't do anything else
    return if $(@)[0].selectedIndex == 0
    console.log $(@)[0].selectedIndex

    # get list of variants that match this option value
    elemId = $(@).find("option:selected").attr("id").split("-")[1]
    variants = options[optionId][elemId]
    ids = for key of variants
      key

    # reset the other option selector by blacking out all choices
    otherOptionId = $("[data-index=" + (optionIndex + 1) % 2 + "]").attr("id").split("_")[2]
    otherOptionSelector = $("#option_type_" + otherOptionId)
    otherOptionSelector.find(".option-value").removeClass("in-stock")
    otherOptionSelector.find(".option-value").each ->
      text = $(@).text().replace("#{outOfStockStr} ", "")
      $(@).text("#{outOfStockStr} #{text}")

    # ...then re-enable the ones that are available, and find the variant_id if both options have been selected
    variant_id
    variants = options[otherOptionId]
    for key,variant of variants
      for id in ids
        if typeof variant[id] == "object"
          if variant[id].in_stock
            $("#option-#{key}").addClass("in-stock")
            $("#option-#{key}").text($("#option-#{key}").text().replace("#{outOfStockStr} ", "") )
          if $("#option-#{key}").val() == $(@).val()
            $('#variant_id').val(variant[id].id)
            $('#cart-form button[type=submit]').attr('disabled', false)
            $("#cart-form .price").text variant[id].price

    # if this selection conflicts with the previous selection, reset the previous selection
    selected = otherOptionSelector.find("option:selected")
    unless selected.hasClass("in-stock")
      selected.parent()[0].selectedIndex = 0

    # fade out the cart button if selection is not complete
    unless $(".selected").length == 2
      $('#cart-form button[type=submit]').attr('disabled', true)
    return

