$(function() {
  const app = (function() {
    return {
      init: function() {
        page.bindEvents();
      }
    };
  })();
  
  const page = (function() {
    function updatePattern(e) {
      e.preventDefault();
      let $form = $(e.target);
      
      ajax.updateProject($form, hideEditPattern);
    }
    
    function hideEditPattern() {
      let $anchor = $('#pattern > a');
      let $patternText = $('#pattern pre');
      let $patternForm = $('#pattern section');
      
      updatePatternText();
      $anchor.removeClass('hidden');
      $patternText.removeClass('hidden');
      $patternForm.addClass('hidden');
      flashMessage('Pattern successfully updated');
    }
    
    function updatePatternText() {
      $('#pattern pre').text($('[data-id="pattern"]').val());
    }
    
    function updateNotes(e) {
      e.preventDefault();
      let $form = $(e.target);
      let message = "Notes were updated"
      
      ajax.updateProject($form, flashMessage.bind(null, message));
    }
    
    function flashMessage(message) {
      let $messageDiv = $('#flash_message');
      $messageDiv.find('p').text(message);
      $messageDiv.toggle();
      setTimeout(function() {
        $messageDiv.fadeOut();
      }, 2000);
    }
    
    function showEditPattern(e) {
      e.preventDefault();
      let $anchor = $('#pattern > a');
      let $patternText = $('#pattern pre');
      let $patternForm = $('#pattern section');
      
      $anchor.addClass('hidden');
      $patternText.addClass('hidden');
      $patternForm.removeClass('hidden');
    }
    
    function toggleNotes(e) {
      e.preventDefault();
      
      toggleText($(e.target), 'Notes');
      $('#notes').toggleClass('hidden');
    }
    
    function toggleText($anchor, text) {
      if ($anchor.text() === 'Show ' + text) {
        $anchor.text('Hide ' + text);
      } else {
        $anchor.text('Show ' + text);
      }
    }
    
    function handleDelete(e) {
      e.preventDefault();
      let form = e.target;
      
      if (confirm('Are you sure you want to delete this project?')) {
        form.submit();
      }
    }
    
    function handleFileInput(e) {
      let $input = $(e.target);
      let $submit = $('.save_img');
      let subStrs = $input.val().split('\\');
      let fileName = subStrs[subStrs.length - 1];
      let $label = $input.siblings('label');
      
      if (fileName) {
        $label.text(fileName);
        $submit.removeClass('hidden');
      } else {
        $label.text('Choose Image...');
        $submit.addClass('hidden');
      }
    }
    
    return {
      bindEvents: function() {
        $(document).on('submit', '#pattern_form', updatePattern);
        $(document).on('submit', '#notes', updateNotes);
        $(document).on('submit', '#delete', handleDelete);
        $(document).on('change', 'input[type="file"]', handleFileInput);
        $(document).on('click', '[data-id="edit-pattern"]', showEditPattern);
        $(document).on('click', '[data-id="show-notes"]', toggleNotes);
      }
    };
  })();
  
  const ajax = (function() {
    return {
      updateProject: function($form, callback) {
        $.ajax({
          url: $form.attr('action'),
          type: $form.attr('method'),
          data: $form.serialize(),
          success: callback
        });
      },
      
      deleteProject: function($form) {
        $.ajax({
          url: $form.attr('action'),
          type: $form.attr('method'),
          data: $form.serialize()
        });
      }
    };
  })();
  
  app.init();
});