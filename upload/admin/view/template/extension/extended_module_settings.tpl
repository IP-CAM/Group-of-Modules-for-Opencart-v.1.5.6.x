<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <?php if ($success) { ?>
  <div class="success"><?php echo $success; ?></div>
  <?php } ?>
  <?php if ($error) { ?>
  <div class="warning"><?php echo $error; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons">
        <a onclick="addGroup();" class="button"><?php echo $button_add_group; ?></a>
        <a onclick="$('#sorts-container').submit();" class="button"><?php echo $button_save; ?></a>
        <a href="<?php echo $reset_href; ?>" class="button"><?php echo $button_reset; ?></a>
        <a href="<?php echo $cancel_href; ?>" class="button"><?php echo $button_cancel; ?></a>
      </div>
    </div>
    <div class="content">
    <form action="<?php echo $settings_href ?>" id="sorts-container" method="post" enctype="multipart/form-data">
      <style>
        .sortable-list {
          padding: 0px 15px;
          overflow: hidden;
          min-height: 20px;
        }
        .sortable-list li, .highlight{
          background: #fff;
          list-style-type: none;
          font-size: 10pt;
          padding: 5px;
          margin: 3px;
        }
        .sortable-list li{
          border: 1px solid #dfdfdf;
          cursor: pointer;
          /*float: left;*/  
          padding: 5px;
          background: #fafafa;
          /*border-radius: 3px;*/
        }
        .sort-heading{
          filter: progid:DXImageTransform.Microsoft.gradient(startColorstr = '#fff', endColorstr = '#e8e6e5');
          -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr = '#fff', endColorstr = '#e8e6e5')";
          background-image: -moz-linear-gradient(top, #fff, #e8e6e5);
          background-image: -ms-linear-gradient(top, #fff, #e8e6e5);
          background-image: -o-linear-gradient(top, #fff, #e8e6e5);
          background-image: -webkit-gradient(linear, center top, center bottom, from(#fff), to(#e8e6e5));
          background-image: -webkit-linear-gradient(top, #fff, #e8e6e5);
          background-image: linear-gradient(top, #fff, #e8e6e5);
        }
        .highlight {
          display: block;
          border: 1px dashed red;
          height: 15px;
          margin: 5px;
        }
        .sort-box{
          margin: 5px;
          border:1px solid #ccc;
          border-radius: 5px 5px 0px 0px;
          background: #fff;
          overflow: hidden;
        }
        .sort-heading{
          margin: 0px;
          height: 35px;
          padding: 0px 5px;
          border-bottom: 1px solid #ccc;
        }
        .sort-heading h3{
          margin: 0px;
          color: #333;
          padding: 10px;
          float: left;
        }
        .system_name{
          float: right;
        }
        .sort-heading .buttons{
          float: right;
          padding-top: 5px;
          margin-right: 5px;
        }
        .sort-heading .buttons .button{
          border-radius: 3px;
          padding: 5px;
          margin-left: 5px;
          opacity: .5;
        }
        .sort-heading .buttons .button:hover{
          opacity: 1;
        }
        .sort-heading .buttons .button.remove{
          background-color: red;
        }
        .sort-content{
          background: #fff;
          /*padding: 5px;*/
          min-height: 20px;
        }
        .transition{
          -webkit-transition: all 100ms ease-in-out;
          -moz-transition: all 100ms ease-in-out;
          -ms-transition: all 100ms ease-in-out;
          -o-transition: all 100ms ease-in-out;
          transition: all 100ms ease-in-out;
        }
        .sort-content .group-settings .input-group input[type="checkbox"]{
          vertical-align: middle;
        }
        .sort-content .group-settings .input-group label{
          padding-right: 10px;
        }
        .sort-content .group-settings .input-group{
          display: inline-block;
          padding: 5px 5px; 
        }
        .sort-content .group-settings{
          padding: 10px;
          display: none;
          background: #efefef;
          border-bottom: 1px solid #ccc;  
        }
        .item-settings{
          display: none;
          margin-top: 10px;
        }
        .icon{
          width:16px;
          height:16px;
          display:inline-block;
        }
        .highlight_item_0{
          background-color: #fafafa !important;
          border-left: 5px solid #dfdfdf !important;
        }
        .highlight_item_1{
          background-color: #fff4d9 !important;
          border-left: 5px solid #ffd166 !important;
        }
        .highlight_item_2{
          background-color: #f4ffed !important;
          border-left: 5px solid #b1db95 !important;
        }
        .highlight_item_3{
          background-color: #ebfcff !important;
          border-left: 5px solid #4d90fe !important;
        }
        .highlight_item_4{
          background-color: #f7f2ff !important;
          border-left: 5px solid #c4a0ff !important;
        }
        .highlight_item_5{
          background-color: #ffeded !important;
          border-left: 5px solid #ffcece !important;
        }
        .highlight_item_6{
          background: #ffc9c9 !important;
          border-left: 5px solid #CE4C38 !important;
        }
        .icon-remove{
          background-image: url('data:image/png;base64,R0lGODlhEAAQAOZOAP///3F6hcopAJMAAP/M//Hz9OTr8ZqksMTL1P8pAP9MDP9sFP+DIP8zAO7x8/D1/LnEz+vx+Flha+Ln7OLm61hhayk0QCo1QMfR2eDo8b/K1M/U2pqiqcfP15WcpcLK05ymsig0P2lyftnf5naBi8XJzZ6lrJGdqmBqdKissYyZpf/+/puotNzk66ayvtbc4rC7x9Xd5n+KlbG7xpiirnJ+ivDz9KKrtrvH1Ojv9ePq8HF8h2x2gvj9/yYyPmRueFxlb4eRm+71+kFLVdrb3c/X4KOnrYGMl3uGke/0+5Sgq1ZfaY6Xn/X4+f///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAAE4ALAAAAAAQABAAAAexgE6CggGFAYOIiAEPEREPh4lOhpOUgwEAmJmaABuQAUktMUUYGhAwLiwnKp41REYmHB5MQUcyN0iQTjsAHU05ICM4SjMQJIg8AAgFBgcvE5gUJYgiycsHDisCApjagj/VzAACBATa5AJOKOAHAAMMDOTvA05A6w7tC/kL804V9uIKAipA52QJgA82dNAQRyBBgwYJyjmRgKmHkAztHA4YAJHfEB8hLFxI0W4AACcbnQQCADs=');
          
        }
        .icon-edit{
          background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAACXBIWXMAAAsSAAALEgHS3X78AAAAB3RJTUUH1gkCDTgyeDqBQAAAAB10RVh0Q29tbWVudABDcmVhdGVkIHdpdGggVGhlIEdJTVDvZCVuAAAAnFBMVEUAAAAAAAAAAACIioXOXADOXACIioUAAABrVzaGiIOHiYSIioWTlZCdn5qpqqiqc0OusKu8vbvCw8HHxsbOXADa29reyLXj4+Pk5OTk5eTl5OTl5eXl5uXm5ubn5+bn5+fn5+jo6Ofo6Ojo6enp6unp6urq6erq6urr6uvr6+vsw6Ls7Ozv7+/1eQD11AD29vb7+/v8rz7+/v7////ZnMblAAAAB3RSTlMAATtEXH2/+FYBcgAAAAFiS0dEMzfVfF4AAACRSURBVBjTRY/pFsFADEZjaxG1RmNQpZYqypj3fzizmvsvN9/5cgIAXQz0wILKIOVHeoPq2dzry2ouvEHV1NdzdcpeQqATN1NQTLMJelEdy8NerBdLor4Vpb9C7y9ZUezEhpn13DqxDfuWBlYwh/3MlbIN6PmBnX+C0iHlKggdSClnVmOIHQaF8TnHyIgEIwn8ANAKFIam4O9vAAAAAElFTkSuQmCC');
        }
      </style>
          <?php $count = 1; foreach ($groups as $group_id => $data): if($group_id==0){$tmp = $count; $count = 0;} ?>
            <div class="sort-box" data-group-id="<?php echo $count ?>">
              <div class="sort-heading">
                <h3><?php echo $data['name']; ?></h3>
                <div class="buttons">
                  <a href="#" onclick="editGroup(<?php echo $count ?>);return false;" class="button transition" title="<?php echo $button_edit ?>"><span class="icon icon-edit"></span></a>
                  <?php if ($group_id !== 0): ?>
                  <a href="#" onclick="deleteGroup(<?php echo $count ?>);return false;" class="button remove transition" title="<?php echo $button_delete ?>"><span class="icon icon-remove"></span></a>
                  <?php endif ?>
                </div>
              </div>
              <div class="sort-content">
                <div class="group-settings">
                  <div class="input-group">
                    <label for="group_<?php echo $count ?>_name"><?php echo $entry_group_name ?></label>
                    <input type="text" class="changer_group_name" id="group_<?php echo $count ?>_name" name="group[<?php echo $count ?>][name]" data-group-id="<?php echo $count ?>" value="<?php echo $data['name']; ?>"/>
                  </div><div class="input-group">
                    <label for="group_<?php echo $count ?>_sort"><?php echo $entry_group_sort ?></label>
                    <select id="group_<?php echo $count ?>_sort" name="group[<?php echo $count ?>][sort]">
                      <?php foreach ($entry_group_sorts as $key => $value): ?>
                        <?php if ($data['sort'] == $key): ?>
                        <option value="<?php echo $key ?>" selected><?php echo $value ?></option>  
                        <?php else: ?>
                        <option value="<?php echo $key ?>"><?php echo $value ?></option>
                        <?php endif ?>
                      <?php endforeach ?>
                    </select>
                  </div>
                </div>
                 <ul class="sortable-list">
                  <?php if (!empty($data['modules'])): ?>
                  <?php foreach ($data['modules'] as $extension): ?>
                  <li class="highlight_item_<?php echo $extension['highlight'] ?>">
                  <span class="system_name">[<?php echo $extension['system_name']; ?>] <a href="#" class="icon icon-edit" onclick="editItem('#<?php echo $extension['system_name']; ?>_settings');return false;"></a></span><?php echo $extension['name'] ?>
                    <input type="hidden" name="module[<?php echo $extension['system_name']; ?>][group]" value="<?php echo $count ?>"> 
                    <div class="item-settings" id="<?php echo $extension['system_name']; ?>_settings">
                      <label for="<?php echo $extension['system_name']; ?>_name"><?php echo $entry_module_name ?></label>
                      <input type="text" name="module[<?php echo $extension['system_name']; ?>][name]" id="<?php echo $extension['system_name']; ?>_name" value="<?php echo htmlspecialchars($extension['name']); ?>">
                      <label for="<?php echo $extension['system_name']; ?>_highlight"><?php echo $entry_module_highlight ?></label>
                      <select name="module[<?php echo $extension['system_name']; ?>][highlight]" onChange="colorize(this);" id="<?php echo $extension['system_name']; ?>_highlight">
                      <?php foreach ($entry_module_h_items as $key => $value): ?>
                        <?php if ($extension['highlight'] == $key): ?>
                        <option value="<?php echo $key ?>" selected="selected"><?php echo $value ?></option>
                        <?php else: ?>
                        <option value="<?php echo $key ?>"><?php echo $value ?></option>
                        <?php endif ?>
                      <?php endforeach ?>
                      </select>
                    </div>
                  </li>
                  <?php endforeach ?>
                  <?php else: ?>
                  <?php endif ?>
                </ul>
              </div>
            </div>
          <?php if($count==0){$count=$tmp;}$count++; endforeach ?>
        </div>
  
<script>
var counter = <?php echo $counter; ?>;
var sorts_container = document.getElementById('sorts-container');
var unnamed_group = $('.sort-box[data-group-id=0]');

$(function() {
  $('.sortable-list').sortable({
    connectWith: ".sortable-list",
    placeholder: "highlight",
    update: function() {
      $('.sort-box', sorts_container).each(function(index, elem) {
        var group_index = parseInt($(elem).attr('data-group-id'));
        $('.sortable-list li', elem).each(function(item_index, item){
          $(item).find('input[name$="[group]"]').val(group_index);
        });
      })}
  }).disableSelection();

  $('#sorts-container').sortable({
    placeholder: "highlight",
    handle: '.sort-heading'
  }).disableSelection();
  changeGroupNameListner();
});

function addGroup(){
  var data = '';
  data += '<div class="sort-box" data-group-id="' + counter + '">';
  data +=   '<div class="sort-heading">';
  data +=     '<h3><?php echo $group_unnamed; ?> ' + counter + '</h3>';
  data +=        '<div class="buttons">';
  data +=          '<a href="#" onclick="editGroup(' + counter + ');return false;" class="button transition" title="<?php echo $button_edit ?>"><span class="icon icon-edit"></span></a>';
  data +=          '<a href="#" onclick="deleteGroup(' + counter + ');return false;" class="button remove transition" title="<?php echo $button_delete ?>"><span class="icon icon-remove"></span></a>';
  data +=        '</div>';
  data +=   '</div>'; 
  data +=   '<div class="sort-content">';
  data +=     '<div class="group-settings">';
  data +=       '<div class="input-group">';
  data +=         '<label for="group_' + counter + '_name"><?php echo $entry_group_name ?></label>';
  data +=         '<input type="text" class="changer_group_name" id="group_' + counter + '_name" name="group[' + counter + '][name]" data-group-id="' + counter + '" value="<?php echo $group_unnamed; ?> ' + counter + '"/>';
  data +=       '</div>';
  data +=       '<div class="input-group">';
  data +=         '<label for="group_' + counter + '_sort"><?php echo $entry_group_sort ?></label>';
  data +=         '<select id="group_' + counter + '_sort" name="group[' + counter + '][sort]">';
  <?php foreach ($entry_group_sorts as $key => $value): ?>
  data +=           '<option value="<?php echo $key ?>"><?php echo $value ?></option>';
  <?php endforeach ?>
  data +=         '</select>';
  data +=       '</div>';
  data +=     '</div>';
  data +=     '<ul class="sortable-list" id="sorted_group' + counter + '">';
  data +=     '</ul>';
  data +=   '</div>';
  data += '</div>';
  $(sorts_container).prepend(data);
    $('.sortable-list').sortable({
      connectWith: ".sortable-list",
      placeholder: "highlight",
      update: function() {
        $('.sort-box', sorts_container).each(function(index, elem) {
          var group_index = parseInt($(elem).attr('data-group-id'));
          $('.sortable-list li', elem).each(function(item_index, item){
            $(item).find('input[name$="[group]"]').val(group_index);
          });
        })}
    }).disableSelection();

  $('#sorts-container').sortable({
    placeholder: "highlight",
    handle: '.sort-heading'
  }).disableSelection();
  changeGroupNameListner();
  counter++;
}
function editItem(Item_id){
  $(Item_id).toggle();
}
function editGroup(group_id){
  var group_container = $('.sort-box[data-group-id=' + group_id + ']');
  $(group_container).find('.group-settings').toggle();
}
function deleteGroup(group_id){
  var group_container = $('.sort-box[data-group-id=' + group_id + ']');
  $('li', group_container).each(function(item_index, item){
    $(item).find('input[name$="[group]"]').val(0);
    $(unnamed_group).find('.sortable-list').append(this);
  });
  $(group_container).remove();
}
function colorize(item){
  $(item).parents('li').removeClass('highlight_item_0 highlight_item_1 highlight_item_2 highlight_item_3 highlight_item_4 highlight_item_5 highlight_item_6').addClass('highlight_item_' + $(item).val() );
}
// Events
  function changeGroupNameListner(){
    $('.changer_group_name').on('change keyup paste', function(){
      var group_id = $(this).attr('data-group-id');
      $('.sort-box[data-group-id=' + group_id + ']').find('h3').html($(this).val());
    });
  }
</script>
  </form>
  </div>
</div>
<?php echo $footer; ?>