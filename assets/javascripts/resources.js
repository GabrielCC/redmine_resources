$(document).ready(function() {
  add_inline_editing();
  $('#issue-form').bind('submit', function(){
    var next_status_id = $('#issue_status_id').val();
    if ((next_status_id != current_status_id) &&
        ($.inArray(next_status_id, window.issue_workflow_list)) &&
        $('#has_resources').val() == '0') {  
      alert('You need to add estimation before moving to this status.');
      $('#estimation').focus();
      return false;
    }
    else{
      return true;
    }
  });
  window.current_status_id = $('#issue_status_id').val(); 
});

function add_inline_editing() {
  $('.resource_estimation_editable').each(function(element) {
    var $editable_element = $(this);
    var id = $editable_element.data('resource-id');
    $editable_element.editable('/issue_resources/' + id, {
        onblur : 'submit',
        method : 'PUT',
        ajaxoptions : {type : 'PUT'},
        name : 'issue_resource[estimation]',
        tooltip   : "Click to edit...",
        'event' : 'editable'
    });
    $('#cell-' + id).live('click', function() {
      $editable_element.trigger('editable');
      $('input', $editable_element).trigger('focus').trigger('select');

    })
  });
}