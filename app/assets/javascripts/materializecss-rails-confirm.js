$(function() {
  $.rails.allowAction = function(link) {
    if (!link.attr("data-confirm")) {
      return true;
    }

    $.rails.showConfirmDialog(link);
    return false;
  };

  $.rails.confirmed = function(link) {
    link.removeAttr("data-confirm");
    return link.trigger("click.rails");
  };

  return $.rails.showConfirmDialog = function(link) {
    var html, message;
    html = void 0;
    message = void 0;
    message = link.attr("data-confirm");

    html= "<div id=\"ms-modal-confirm\" class=\"modal open\" style=\"z-index: 1003; display: block; opacity: 1; transform: scaleX(1); top: 0%;\">" +
           "<div class=\"valign-wrapper\" style=\"height:100%;\">" +
           "<div class=\"modal-content\">" +
           "<a href=\"#!\" class=\"modal-action modal-close ms-close-x waves-effect waves-green btn-flat right close\" data-remote=\"true\">" +
              "  <i class=\"material-icons\">close</i>" +
              "</a>" +
            "<div class=\"row\">" +
              "<div class=\"col s12 center-align\">" +
                  "<p>Are you sure you want to delete it?</p>" +
                "</div>" +
              "</div>" +
              "<div class=\"row\">" +
                  "<div class=\"col s12 center-align\">" +
                    "<a class=\"waves-effect waves-light btn-large modal-close confirm\">Ok</a>" +
                  "</div>" +
              "</div>" +
        "</div>" +
      "</div>" +
    "</div>"



    $("body").append(html);

    $("#ms-modal-confirm").modal({
      complete: function() {
        return $("#ms-modal-confirm").remove();
      }
    });

    $("#ms-modal-confirm a.ms-close-x").on("click", function() {
      return $(this).parents("#ms-modal-confirm").removeClass("open").css("display","none");
    });

    return $("#ms-modal-confirm .confirm").on("click", function() {
      $(this).parents("#ms-modal-confirm").removeClass("open").css("display", "none");;
      return $.rails.confirmed(link);
    });
  };
});
