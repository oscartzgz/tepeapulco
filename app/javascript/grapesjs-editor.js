// Import GrapeJS and plugins
import grapesjs from 'grapesjs';
import gjsBlocksBasic from 'grapesjs-blocks-basic';
import gjsPresetWebpage from 'grapesjs-preset-webpage';

// Ensure GrapeJS styles are loaded
const loadGrapeJSStyles = () => {
  if (!document.querySelector('link[href*="grapes.min.css"]')) {
    const grapejsStyleLink = document.createElement('link');
    grapejsStyleLink.rel = 'stylesheet';
    grapejsStyleLink.href = 'https://unpkg.com/grapesjs@0.21.4/dist/css/grapes.min.css';
    document.head.appendChild(grapejsStyleLink);
  }
  
  if (!document.querySelector('link[href*="grapesjs-preset-webpage.min.css"]')) {
    const presetStyleLink = document.createElement('link');
    presetStyleLink.rel = 'stylesheet';
    presetStyleLink.href = 'https://unpkg.com/grapesjs-preset-webpage@1.0.2/dist/grapesjs-preset-webpage.min.css';
    document.head.appendChild(presetStyleLink);
  }
};

document.addEventListener('DOMContentLoaded', () => {
  const editorElement = document.getElementById('gjs');
  
  if (!editorElement) return;
  
  // Get the initial page content from the data attribute
  const pageContent = editorElement.dataset.content || '{}';
  const pageStyles = editorElement.dataset.styles || '';
  const pageId = editorElement.dataset.pageId;
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  
  // Load external CSS stylesheets
  loadGrapeJSStyles();
  
  // Add custom styles for GrapeJS
  const customStyles = document.createElement('style');
  customStyles.textContent = `
    .gjs-one-bg { background-color: #202020; }
    .gjs-two-color { color: #fff; }
    .gjs-two-color-h:hover { color: #f5f5f5; }
    .gjs-three-bg { background-color: #3b3b3b; color: white; }
    .gjs-four-color, .gjs-four-color-h:hover { color: #4285f4; }
    
    .gjs-editor { height: calc(100vh - 80px); }
    .gjs-panel { padding: 0; }
    .gjs-sm-sector .gjs-sm-title { border-top: none; }
    .gjs-sm-sector .gjs-sm-field { width: auto; }
    .gjs-sm-sector .gjs-clm-tags .gjs-sm-field,
    .gjs-sm-sector .gjs-clm-select .gjs-sm-field { width: 100%; }
    .gjs-mdl-dialog { max-width: 90%; width: auto; }
    
    .editor-container { height: calc(100vh - 80px); position: relative; }
    
    .editor-actions {
      background: #202020;
      padding: 10px;
      display: flex;
      justify-content: space-between;
      border-bottom: 1px solid #3b3b3b;
    }
    
    .editor-loader {
      position: absolute; top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0, 0, 0, 0.7);
      display: flex; align-items: center; justify-content: center;
      z-index: 100; color: white; font-size: 18px;
    }
    
    @keyframes pulse {
      0% { opacity: 0.5; }
      50% { opacity: 1; }
      100% { opacity: 0.5; }
    }
    
    .editor-loader span { animation: pulse 1.5s infinite; }
  `;
  document.head.appendChild(customStyles);
  
  // Initialize GrapeJS editor
  const editor = grapesjs.init({
    container: '#gjs',
    height: '100%',
    width: 'auto',
    fromElement: false,
    // Load initial content from the data attribute
    components: pageContent ? (typeof pageContent === 'string' ? JSON.parse(pageContent) : pageContent) : [],
    style: pageStyles,
    storageManager: false,
    deviceManager: {
      devices: [
        {
          name: 'Desktop',
          width: '',
        },
        {
          name: 'Tablet',
          width: '768px',
          widthMedia: '768px',
        },
        {
          name: 'Mobile',
          width: '375px',
          widthMedia: '375px',
        },
      ]
    },
    layerManager: {
      appendTo: '.layers-container'
    },
    panels: {
      defaults: [
        {
          id: 'panel-switcher',
          el: '.panel__switcher',
          buttons: [
            {
              id: 'show-layers',
              active: true,
              label: 'Capas',
              command: 'show-layers',
              toggleable: false,
            },
            {
              id: 'show-style',
              active: true,
              label: 'Estilos',
              command: 'show-styles',
              toggleable: false,
            },
            {
              id: 'show-traits',
              active: true,
              label: 'Propiedades',
              command: 'show-traits',
              toggleable: false,
            }
          ]
        },
        {
          id: 'panel-devices',
          el: '.panel__devices',
          buttons: [
            {
              id: 'device-desktop',
              label: 'Desktop',
              command: 'set-device-desktop',
              active: true,
              togglable: false,
            },
            {
              id: 'device-tablet',
              label: 'Tablet',
              command: 'set-device-tablet',
              togglable: false,
            },
            {
              id: 'device-mobile',
              label: 'Mobile',
              command: 'set-device-mobile',
              togglable: false,
            }
          ]
        }
      ]
    },
    plugins: [
      gjsBlocksBasic,
      gjsPresetWebpage
    ],
    pluginsOpts: {
      gjsBlocksBasic: {},
      gjsPresetWebpage: {}
    }
  });
  
  // Add commands for device switching
  editor.Commands.add('set-device-desktop', {
    run: (editor) => editor.setDevice('Desktop')
  });
  
  editor.Commands.add('set-device-tablet', {
    run: (editor) => editor.setDevice('Tablet')
  });
  
  editor.Commands.add('set-device-mobile', {
    run: (editor) => editor.setDevice('Mobile')
  });
  
  // Handle save button
  document.getElementById('save-page').addEventListener('click', () => {
    const content = JSON.stringify(editor.getComponents());
    const styles = editor.getCss();
    const assets = JSON.stringify(editor.AssetManager.getAll().models.map(asset => asset.attributes));
    
    // Show a loading overlay
    const loader = document.createElement('div');
    loader.className = 'editor-loader';
    loader.innerHTML = '<span>Guardando...</span>';
    document.querySelector('.editor-container').appendChild(loader);
    
    // Send data to server
    fetch(`/admin/pages/${pageId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
      },
      body: JSON.stringify({
        page: {
          content,
          styles,
          assets
        }
      })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Error al guardar la página');
      }
      return response.json();
    })
    .then(data => {
      // Remove loading overlay
      loader.remove();
      
      // Show success message
      const successMessage = document.createElement('div');
      successMessage.className = 'fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded shadow-lg';
      successMessage.textContent = 'Página guardada exitosamente';
      document.body.appendChild(successMessage);
      
      // Remove success message after 2 seconds
      setTimeout(() => {
        successMessage.remove();
      }, 2000);
    })
    .catch(error => {
      // Remove loading overlay
      loader.remove();
      
      // Show error message
      const errorMessage = document.createElement('div');
      errorMessage.className = 'fixed top-4 right-4 bg-red-500 text-white px-4 py-2 rounded shadow-lg';
      errorMessage.textContent = error.message;
      document.body.appendChild(errorMessage);
      
      // Remove error message after 3 seconds
      setTimeout(() => {
        errorMessage.remove();
      }, 3000);
    });
  });
  
  // Handle back button
  document.getElementById('back-button')?.addEventListener('click', () => {
    window.location.href = '/admin/pages';
  });
});