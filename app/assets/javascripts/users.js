$(document).on('turbolinks:load',function(){
  $('select#user_role').on('change', function(){

    var newSelect = $('select').val();
    console.log(newSelect);
    var userId = $(this).parents('.selected_role').attr('data');
    $.ajax({
      url: 'users/roleUpdate',
      type: 'POST',
      dataType: 'json',
      data: {'user_id': userId, 'new_role': newSelect},
      success: function(){
        // alert ('user role was changed to' + newSelect);
      }
    });
  });

  $(document).on("change", 'input#user_avatar', uploadAvatar);
  // CHANGE IMAGE IN USER NEW FILE UPLOAD
  $(document).on("mouseout", 'label[for="user_avatar"]', mouseOutAvatar);
  $(document).on("mouseover", 'label[for="user_avatar"]', mouseOverAvatar);
})
// END
