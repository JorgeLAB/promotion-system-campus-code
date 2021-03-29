window.addEventListener("load", () => {
  let field_search = $("#search_promotion");
  let tbody_search_promotions = $('#list_promotions tbody')


  const SEARCH_PROMOTION = (name='') => {
    $.ajax({
      url: '/promotions/search',
      type: 'POST',
      data: {'name': name},
      dataType: 'json',
      success: function (response) {

        promotions = response['promotions']

        tbody_search_promotions.html("");

        promotions.forEach((item, index) => {
          tbody_search_promotions.append(`
            <tr>
              <td class="text-center add_share" id=${index}><img src="icon_user_add.svg"></td>
              <td class="text-center">${item.name}</td>
            </tr>
          `)
        })

      }
    })
  }

  field_search.on('submit',(event) => {
    SEARCH_PROMOTION('')
  });

});
