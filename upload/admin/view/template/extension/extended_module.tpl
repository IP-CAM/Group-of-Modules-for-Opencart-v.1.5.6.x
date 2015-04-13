<?php echo $header; ?>
<style>
  .list tbody td {
    background: none;
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
  .sort-heading{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr = '#fff', endColorstr = '#f4f4f4');
    -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr = '#fff', endColorstr = '#f4f4f4')";
    background-image: -moz-linear-gradient(top, #fff, #f4f4f4);
    background-image: -ms-linear-gradient(top, #fff, #f4f4f4);
    background-image: -o-linear-gradient(top, #fff, #f4f4f4);
    background-image: -webkit-gradient(linear, center top, center bottom, from(#fff), to(#f4f4f4));
    background-image: -webkit-linear-gradient(top, #fff, #f4f4f4);
    background-image: linear-gradient(top, #fff, #f4f4f4);
  }
  .sort-heading h3{
    margin: 0px;
    color: #333;
    padding: 10px;
    float: left;
  }
  .sort-content{
    background: #fff;
    padding: 10px;
    min-height: 20px;
  }
  table.list thead{
    display: none;
  }
  table.list{
    margin-bottom: auto;
  }
</style>
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
        <a href="<?php echo $settings_href ?>" class="button"><?php echo $button_settings; ?></a>
      </div>
    </div>
    <div class="content">
    <?php if ($groups) { ?>
      <?php foreach ($groups as $group) { ?>
      <div class="sort-box">
        <div class="sort-heading">
          <h3><?php echo $group['name']; ?></h3>
        </div>
        <div class="sort-content">
          <table class="list">
            <thead>
              <tr class="highlight_item_0">
                <td class="left"><?php echo $column_name; ?></td>
                <td class="right"><?php echo $column_action; ?></td>
              </tr>
            </thead>
            <tbody>
              <?php foreach ($group['modules'] as $module_id => $extension): ?>
              <tr class="highlight_item_<?php echo $extension['highlight'] ?>">
                <td class="left"><?php echo $extension['name']; ?></td>
                <td class="right"><?php foreach ($extension['action'] as $action) { ?>
                  [ <a href="<?php echo $action['href']; ?>"><?php echo $action['text']; ?></a> ]
                  <?php } ?></td>
              </tr>
              <?php endforeach ?>
            </tbody>
          </table>
        </div>
      </div>
      <?php } ?>
      <?php } else { ?>
      <?php echo $text_no_results; ?>
      <?php } ?>
    </div>
  </div>
</div>
<?php echo $footer; ?>