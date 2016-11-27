// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
$(document).on('ready page:load',function(){
	$('#producto_to_add').focus();

	$(document).on('click','#remove, #restore, #delete',{},function(){
		var task = $(this).attr('id').toString();
		//alert(action);
		if(task=="delete")
		{
			var r = confirm("¿Estás segur@ de que lo quieres eliminar?")
			if(r==false)
				return;
		}
		var checkedValues = $('input:checkbox:checked').map(function() {
    		return this.value;
		}).get();
		
		$.ajax({
                url: '/remove_restore_from_list',
                type: 'POST',
                dataType: 'script',
                data: 'checkedValues='+checkedValues+'&task='+task,
                success: function(msg){
                	
                }
                
            });
	});

	
});