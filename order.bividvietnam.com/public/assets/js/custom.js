jQuery(document).ready(function($) {
    $(".bx.bx-menu.bx-sm").click(function(){
        $("html").addClass("layout-menu-expanded");
    });
    $("#close-menu").click(function(){
        $("html").removeClass("layout-menu-expanded");
    });
});
