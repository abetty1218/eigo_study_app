$(document).on('click','input[type="radio"]',function(){
  $(this).parents(".fields").find('input[type="radio"]').prop('checked', false);
  $(this).prop('checked', true);
});


$(document).on('click','.add_question_btn',function(){
  $(this).prev(".fields").addClass('mt-3');
});

function questionadderror(choice_count,first_count){
  $(".question_add").children(".fields:visible").each(function(index, element){
    each_count = $(element).find('.fields:visible').find('.choice:checked').length;
    if(each_count == 0){
      choice_count[index+first_count+1] = each_count;
    }
  });
}

function problemquestionerror(choice_count){
  let first_count = $(".container").children(".mt-3").children(".new_problem").children(".fields:visible").length
  $(".container").children(".mt-3").children(".new_problem").children(".fields:visible").each(function(index, element){
    each_count = $(element).find('.fields:visible').find('.choice:checked').length;
    if(each_count == 0){
      choice_count[index+1] = each_count;
    }
  });
  questionadderror(choice_count,first_count);
}

function questionnewerror(choice_count){
  let first_count = $(".container").children(".mt-3").children(".edit_problem").children(".fields:visible").length
  $(".container").children(".mt-3").children(".edit_problem").children(".fields:visible").each(function(index, element){
    each_count = $(element).find('.fields:visible').find('.choice:checked').length;
    if(each_count == 0){
      choice_count[index+1] = each_count;
    }
  });
  questionadderror(choice_count,first_count);
}


function questionalerterror(choice_count){
  if(Object.keys(choice_count).length > 0){
    alert_statement = []
    $.each(choice_count,function(index, element){
      alert_statement.push(index + '番目の質問の解答となる選択肢にチェックがはいっていません。');
    });
    statement = alert_statement.join("\n");
    alert(statement);
    return false;
  }
}

function questioneditalerterror(){
  let count;
  count = $('.fields:visible').find('.choice:checked').length;
  if(count == 0){
    alert("解答となる選択肢にチェックがはいっていません。");
    return false;
  }
}

function questionerror(){
  let choice_count = {};
  questionnewerror(choice_count);
  return questionalerterror(choice_count);
}

function problemerror(){
  let choice_count = {};
  problemquestionerror(choice_count)
  return questionalerterror(choice_count);
}
