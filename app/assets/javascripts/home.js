$(document).on('turbolinks:load',function(){
  /***** Autocomplete with jQuery Autocomplete *********/
  var startDatepicker = [0,0,0];
  if (gon.startDate !== null){
    startDatepicker = gon.startDate;
  }
  $('#application-date .datepicker').pickadate({
      selectMonths: true, // Creates a dropdown to control month
      selectYears: 15, // Creates a dropdown of 15 years to control year
      closeOnSelect: true,
      clear: '',
      hiddenName: true,
      disable: [
        { from: [0,0,0], to: gon.startDate }
       ],
      onClose: function (){
        $('#form_date').val(this.get());
        var $activeCollaborators = $('#application-date input#active-collaborators');

        $activeCollaborators.val(getActiveCollaborators()) ;

        // console.log(this.$root.parent('form'));
        // $.ajax({
        //   complete:function(request){},
        //   data:'date='+ this.get(),
        //   dataType:'script',
        //   type:'GET',
        //   url: this.$root.parent('form').attr('action')
        // })
         this.$root.parent('form').submit();
       },
       onStart: function (){
          var dateVar = gon.current_date;
          var dsplit = dateVar.split("-");
          var date = new Date(dsplit[0],dsplit[1]-1,dsplit[2]);
          this.set('select', [date.getFullYear(), date.getMonth(), date.getDate()]);
          $('#form_date').val(this.get());
          // this.$root.parent('form').submit();

      }
    });
  });


function getActiveCollaborators(){
  var $ulCollaboration_users = $('ul#collaboration-users'),
      arrayActiveCorraborators = [];

  $('li', $ulCollaboration_users).each(function( index ) {
     if ($( this ).hasClass('active')) {
        arrayActiveCorraborators.push($( this ).attr('id'));
     }
});
  return arrayActiveCorraborators;
}
