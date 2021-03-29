window.addEventListener("load", () => {
  let field_search = $("#search_promotion ");

  const SEARCH_PROMOTION = (name='') => {
    $.ajax({
      url: '/promotions/search',
      type: 'POST',
      data: {'name': name},
      dataType: 'json',
      success: function (response) {
      }
    })
  }

  field_search.on('submit',(event) => {
    SEARCH_PROMOTION('')
  });

});
