// Load shared head content from head.html and inject it into the page
async function loadHeadContent() {
    try {
        const response = await fetch('head.html');
        const headContent = await response.text();
        document.head.insertAdjacentHTML('beforeend', headContent);
    } catch (error) {
        console.error('Failed to load head.html:', error);
    }
}

// Execute immediately
loadHeadContent();