<?php
class ControllerExtensionExtendedModule extends Controller {
	private $error = array();

	public function index() {
		$this->load->language('extension/extended_module');
		 
		$this->document->setTitle($this->language->get('modules_heading_title')); 

  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('modules_heading_title'),
			'href'      => $this->url->link('extension/extended_module', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
		
		$this->data['heading_title'] = $this->language->get('modules_heading_title');

		// Text
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_confirm'] = $this->language->get('text_confirm');
		
		// Button 
		$this->data['button_settings'] = $this->language->get('button_settings');

		// Columns 
		$this->data['column_name'] = $this->language->get('column_name');
		$this->data['column_action'] = $this->language->get('column_action');

		if (isset($this->session->data['success'])) {
			$this->data['success'] = $this->session->data['success'];
		
			unset($this->session->data['success']);
		} else {
			$this->data['success'] = '';
		}

		if (isset($this->session->data['error'])) {
			$this->data['error'] = $this->session->data['error'];
		
			unset($this->session->data['error']);
		} else {
			$this->data['error'] = '';
		}

		$this->load->model('setting/extension');
		
		// Links
		$this->data['settings_href'] = $this->url->link('extension/extended_module/settings', 'token=' . $this->session->data['token'], 'SSL');
		
		$this->load->model('setting/setting');
		
		$em_data = $this->model_setting_setting->getSetting('extended_module');
		
		if (isset($em_data['data'])) {
			$em_data = $em_data['data'];
		}
		
		if (!isset($em_data[0])) {
			$em_data[0] = array(
				'name' => $this->language->get('group_unsorted'),
				'sort' => 0,
				'sort_order' => 0,
				'modules' => array()
			);
		}
		$mods_sort_array = array();

		foreach ($em_data as $group_id => $group_data) {
			if (isset($group_data['modules'])) {
				foreach ($group_data['modules'] as $module_id => $module_data) {
					$mods_sort_array[$module_id] = $group_id;
				}
			}
		}

		$extensions = $this->model_setting_extension->getInstalled('module');

		foreach ($extensions as $key => $value) {
			if (!file_exists(DIR_APPLICATION . 'controller/module/' . $value . '.php')) {
				$this->model_setting_extension->uninstall('module', $value);
				
				unset($extensions[$key]);
			}
		}
		
		$this->data['extensions'] = array();
						
		$files = glob(DIR_APPLICATION . 'controller/module/*.php');

		if ($files) {
			foreach ($files as $file) {
				$extension = basename($file, '.php');
				
				$this->load->language('module/' . $extension);
	
				$action = array();
				
				if (!in_array($extension, $extensions)) {
					$action[] = array(
						'text' => $this->language->get('text_install'),
						'href' => $this->url->link('extension/module/install', 'token=' . $this->session->data['token'] . '&extension=' . $extension, 'SSL')
					);
				} else {
					$action[] = array(
						'text' => $this->language->get('text_edit'),
						'href' => $this->url->link('module/' . $extension . '', 'token=' . $this->session->data['token'], 'SSL')
					);
								
					$action[] = array(
						'text' => $this->language->get('text_uninstall'),
						'href' => $this->url->link('extension/module/uninstall', 'token=' . $this->session->data['token'] . '&extension=' . $extension, 'SSL')
					);
				}
				if (array_key_exists($extension, $mods_sort_array)) {
					$em_data[$mods_sort_array[$extension]]['modules'][$extension]['name'] = htmlspecialchars_decode($em_data[$mods_sort_array[$extension]]['modules'][$extension]['name']);
					$em_data[$mods_sort_array[$extension]]['modules'][$extension]['system_name'] = $extension;
					$em_data[$mods_sort_array[$extension]]['modules'][$extension]['action'] = $action;
				}else{
					$em_data[0]['modules'][$extension] = array(
						'name'   		=> $this->language->get('heading_title'),
						'system_name'   => $extension,
						'action' 		=> $action,
						'highlight'   		=> 0,
					);
				}
				$this->data['extensions'][] = array(
					'name'   		=> $this->language->get('heading_title'),
					'system_name'   => $extension,
					'action' 		=> $action
				);
			}
		}
		// var_dump($em_data);
		$this->data['counter'] = count($em_data);
		
		function items_nat_cmp($a, $b) {
			return strcasecmp(strip_tags($a['name']), strip_tags($b['name']));	
		} 

		function groups_nat_cmp($a, $b) { 
			if ($a['sort_order'] == $b['sort_order']) {
				return 0;
			}
			return ($a['sort_order'] < $b['sort_order']) ? -1 : 1;
		} 
		
		uasort($em_data, 'groups_nat_cmp');

		foreach ($em_data as $group_id => $group_data) {
			if ((int)$group_data['sort'] == 1) {
				uasort($group_data['modules'], 'items_nat_cmp');
				$em_data[$group_id]['modules'] = $group_data['modules'];
			}
		}

		$this->data['groups'] = $em_data;

		$this->template = 'extension/extended_module.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}
	
	public function settings() {
		$this->load->language('extension/extended_module');
		
		$this->document->setTitle($this->language->get('settings_heading_title')); 
		 
		$this->load->model('setting/setting');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			// var_dump($this->request->post);
			$data = array();

			$new_group_id = 1;
			$sort_order = 1;
			$tmp_group_id = 1;

			foreach ($this->request->post['group'] as $group_id => $group_data) {
				if ((int)$group_id == 0) {
					$tmp_group_id = $new_group_id;
					$new_group_id = 0;
				}

				$data[$new_group_id] = $group_data;


				$data[$new_group_id]['sort_order'] = $sort_order;

				foreach ($this->request->post['module'] as $module_id => $module_data) {
					if ($group_id == $module_data['group']) {
						$data[$new_group_id]['modules'][$module_id] = $module_data;
					}
				}

				if ($group_id == 0) {
					$new_group_id = $tmp_group_id;
				}

				$new_group_id++;
				$sort_order++;
			}
			
			// var_dump($data);
			
			$this->model_setting_setting->editSetting('extended_module', array('data'=>$data));
			

			$this->session->data['success'] = $this->language->get('text_success');

			$this->redirect($this->url->link('extension/extended_module/settings', 'token=' . $this->session->data['token'], 'SSL'));
		}
		

  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('modules_heading_title'),
			'href'      => $this->url->link('extension/extended_module', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('settings_heading_title'),
			'href'      => $this->url->link('extension/extended_module/settings', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
		
		$this->data['heading_title'] = $this->language->get('settings_heading_title');

		// Text
		$this->data['text_no_results'] = $this->language->get('text_no_results');
		$this->data['text_confirm'] = $this->language->get('text_confirm');
		
		// Button 
		$this->data['button_settings'] 	= $this->language->get('button_settings');
		$this->data['button_add_group'] = $this->language->get('button_add_group');
		$this->data['button_save'] 		= $this->language->get('button_save');
		$this->data['button_cancel'] 	= $this->language->get('button_cancel');
		$this->data['button_delete'] 	= $this->language->get('button_delete');
		$this->data['button_edit'] 		= $this->language->get('button_edit');
		$this->data['button_reset'] 		= $this->language->get('button_reset');
		
		// Entry
		$this->data['entry_group_name'] 			= $this->language->get('entry_group_name');
		$this->data['entry_group_sort'] 			= $this->language->get('entry_group_sort');
			$this->data['entry_group_sorts'] 			= $this->language->get('entry_group_sorts');
		
		$this->data['entry_module_name'] 			= $this->language->get('entry_module_name');
		$this->data['entry_module_highlight'] 			= $this->language->get('entry_module_highlight');
		$this->data['entry_module_h_items'] 			= $this->language->get('entry_module_h_items');
		
		// Group
		$this->data['group_unsorted'] 	= $this->language->get('group_unsorted');
		$this->data['group_unnamed'] 	= $this->language->get('group_unnamed');

		// Columns 
		$this->data['column_name'] = $this->language->get('column_name');
		$this->data['column_action'] = $this->language->get('column_action');

		if (isset($this->session->data['success'])) {
			$this->data['success'] = $this->session->data['success'];
		
			unset($this->session->data['success']);
		} else {
			$this->data['success'] = '';
		}

		if (isset($this->session->data['error'])) {
			$this->data['error'] = $this->session->data['error'];
		
			unset($this->session->data['error']);
		} else {
			$this->data['error'] = '';
		}

		$this->load->model('setting/extension');
		
		// Links
		$this->data['settings_href'] = $this->url->link('extension/extended_module/settings', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['settings_href'] = $this->url->link('extension/extended_module/settings', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['cancel_href'] = $this->url->link('extension/extended_module', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['reset_href'] = $this->url->link('extension/extended_module/reset', 'token=' . $this->session->data['token'], 'SSL');
		
		$em_data = $this->model_setting_setting->getSetting('extended_module');
		
		if (isset($em_data['data'])) {
			$em_data = $em_data['data'];
		}
		
		if (!isset($em_data[0])) {
			$em_data[0] = array(
				'name' => $this->language->get('group_unsorted'),
				'sort' => 0,
				'sort_order' => 0,
				'modules' => array()
			);
		}
		$mods_sort_array = array();

		foreach ($em_data as $group_id => $group_data) {
			if (isset($group_data['modules'])) {
				foreach ($group_data['modules'] as $module_id => $module_data) {
					$mods_sort_array[$module_id] = $group_id;
				}
			}
		}

		$extensions = $this->model_setting_extension->getInstalled('module');
		
		foreach ($extensions as $key => $value) {
			if (!file_exists(DIR_APPLICATION . 'controller/module/' . $value . '.php')) {
				$this->model_setting_extension->uninstall('module', $value);
				
				unset($extensions[$key]);
			}
		}
		
		$this->data['extensions'] = array();
						
		$files = glob(DIR_APPLICATION . 'controller/module/*.php');

		if ($files) {
			foreach ($files as $file) {
				$extension = basename($file, '.php');
				
				$this->load->language('module/' . $extension);
	
				$action = array();
				
				if (!in_array($extension, $extensions)) {
					$action[] = array(
						'text' => $this->language->get('text_install'),
						'href' => $this->url->link('extension/module/install', 'token=' . $this->session->data['token'] . '&extension=' . $extension, 'SSL')
					);
				} else {
					$action[] = array(
						'text' => $this->language->get('text_edit'),
						'href' => $this->url->link('module/' . $extension . '', 'token=' . $this->session->data['token'], 'SSL')
					);
								
					$action[] = array(
						'text' => $this->language->get('text_uninstall'),
						'href' => $this->url->link('extension/module/uninstall', 'token=' . $this->session->data['token'] . '&extension=' . $extension, 'SSL')
					);
				}
				if (array_key_exists($extension, $mods_sort_array)) {
					$em_data[$mods_sort_array[$extension]]['modules'][$extension]['name'] = htmlspecialchars_decode($em_data[$mods_sort_array[$extension]]['modules'][$extension]['name']);
					$em_data[$mods_sort_array[$extension]]['modules'][$extension]['system_name'] = $extension;
					$em_data[$mods_sort_array[$extension]]['modules'][$extension]['action'] = $action;
				}else{
					$em_data[0]['modules'][$extension] = array(
						'name'   		=> $this->language->get('heading_title'),
						'system_name'   => $extension,
						'action' 		=> $action,
						'highlight'   		=> 0,
					);
				}
				$this->data['extensions'][] = array(
					'name'   		=> $this->language->get('heading_title'),
					'system_name'   => $extension,
					'action' 		=> $action
				);
			}
		}
		// var_dump($em_data);
		$this->data['counter'] = count($em_data);
		
		function items_nat_cmp($a, $b) {
			return strcasecmp(strip_tags($a['name']), strip_tags($b['name']));	
		} 

		function groups_nat_cmp($a, $b) { 
			if ($a['sort_order'] == $b['sort_order']) {
				return 0;
			}
			return ($a['sort_order'] < $b['sort_order']) ? -1 : 1;
		} 
		
		uasort($em_data, 'groups_nat_cmp');

		foreach ($em_data as $group_id => $group_data) {
			if ((int)$group_data['sort'] == 1) {
				uasort($group_data['modules'], 'items_nat_cmp');
				$em_data[$group_id]['modules'] = $group_data['modules'];
			}
		}
		
		$this->data['groups'] = $em_data;

		$this->template = 'extension/extended_module_settings.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}
	
	public function reset() {
		$this->load->language('extension/extended_module');
		 
		$this->load->model('setting/setting');
		
		$this->model_setting_setting->deleteSetting('extended_module');

  		$this->session->data['success'] = $this->language->get('text_success_reset');

		$this->redirect($this->url->link('extension/extended_module/settings', 'token=' . $this->session->data['token'], 'SSL'));

	}
	public function install() {
		$this->load->language('extension/extended_module');
		
		if (!$this->user->hasPermission('modify', 'extension/module')) {
			$this->session->data['error'] = $this->language->get('error_permission'); 
			
			$this->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));
		} else {
			$this->load->model('setting/extension');
			
			$this->model_setting_extension->install('module', $this->request->get['extension']);

			$this->load->model('user/user_group');
		
			$this->model_user_user_group->addPermission($this->user->getId(), 'access', 'module/' . $this->request->get['extension']);
			$this->model_user_user_group->addPermission($this->user->getId(), 'modify', 'module/' . $this->request->get['extension']);
			
			require_once(DIR_APPLICATION . 'controller/module/' . $this->request->get['extension'] . '.php');
			
			$class = 'ControllerModule' . str_replace('_', '', $this->request->get['extension']);
			$class = new $class($this->registry);
			
			if (method_exists($class, 'install')) {
				$class->install();
			}
			
			$this->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));
		}
	}
	
	public function uninstall() {
		$this->load->language('extension/extended_module');
		
		if (!$this->user->hasPermission('modify', 'extension/module')) {
			$this->session->data['error'] = $this->language->get('error_permission'); 
			
			$this->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));
		} else {		
			$this->load->model('setting/extension');
			$this->load->model('setting/setting');
					
			$this->model_setting_extension->uninstall('module', $this->request->get['extension']);
		
			$this->model_setting_setting->deleteSetting($this->request->get['extension']);
		
			require_once(DIR_APPLICATION . 'controller/module/' . $this->request->get['extension'] . '.php');
			
			$class = 'ControllerModule' . str_replace('_', '', $this->request->get['extension']);
			$class = new $class($this->registry);
			
			if (method_exists($class, 'uninstall')) {
				$class->uninstall();
			}
		
			$this->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));	
		}
	}
	
	protected function validate() {
		if (!$this->user->hasPermission('modify', 'extension/extended_module')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
		if (!$this->error) {
			return true;
		} else {
			return false;
		}
	}

}
?>