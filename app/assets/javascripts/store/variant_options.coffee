window.variantOptions = (params) ->
  options = params['options']

  # select a variant option
  $(document).on "change", ".variant-option-values", ->
    parent = $(@).parents('.variant-options')
    optionId = $(@).parents(".variant-options").attr("id").split("_")[2]
    optionIndex = $(@).parents(".variant-options").data("index")
    elemId = $(@).find("option:selected").attr("id").split("-")[1]

    # reset options if user selects something that's not in-stock
    unless $(@).hasClass("in-stock")
      $(@).find('.option-value').addClass("in-stock")

    # get list of variants that match this option value
    variants = options[optionId][elemId]
    ids = for key of variants
      key

    # reset the other option selector by blacking out all choices
    otherOptionId = $("[data-index=" + (optionIndex + 1) % 2 + "]").attr("id").split("_")[2]
    otherOptionSelector = $("#option_type_" + otherOptionId)
    otherOptionSelector.find(".option-value").removeClass("in-stock")
    otherOptionSelector.find(".option-value").each ->
      text = $(@).text().replace("[X] ", "")
      $(@).text("[X] " + text)

    # ...then re-enable the ones that are available, and find the variant_id if both options have been selected
    variant_id
    variants = options[otherOptionId]
    for key,variant of variants
      for id in ids
        if typeof variant[id] == "object"
          if variant[id].in_stock
            $("#option-#{key}").addClass("in-stock")
            $("#option-#{key}").text($("#option-#{key}").text().replace("[X] ", "") )
          if $("#option-#{key}").val() == $(@).val()
            $('#variant_id').val(variant[id].id)
            $('#cart-form button[type=submit]').attr('disabled', false)
            $("#cart-form .price").text variant[id].price

    # if this selection conflicts with the previous selection, reset the previous selection
    selected = otherOptionSelector.find("option:selected")
    unless selected.hasClass("in-stock")
      selected.parent().val("")

    # fade out the cart button if selection is not complete
    unless $(".selected").length == 2
      $('#cart-form button[type=submit]').attr('disabled', true)
    return

