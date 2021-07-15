$('document').ready(function(){
  
  function intro() {
    $('img').attr("src", "./voltage_intro.gif");
    setTimeout(function() {
      $('img').attr('src', "./empty.png");
    }, 3000)
  }
  
  function success() {
    $('img').attr("src", "./voltage_success.gif");
    setTimeout(function() {
      $('img').attr('src', "./empty.png");
    }, 3000)
  }
  
  function fail() {
    $('img').attr("src", "./voltage_fail.gif");
    setTimeout(function() {
      $('img').attr('src', "./empty.png");
    }, 3000)
  }

  window.addEventListener("message", (event) => {
    if (event.data.type == "intro") {
      intro();
    } else if (event.data.type == "success") {
      success();
    } else if (event.data.type == "fail") {
      fail();
    }
  });

});



