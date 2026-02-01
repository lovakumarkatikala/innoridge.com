
function loadFooter() {
    fetch('footer.html')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.text();
        })
        .then(data => {
            // Insert the footer content into the placeholder div
            document.getElementById('footer-placeholder').innerHTML = data;
        })
        .catch(error => {
            console.error('There was a problem loading the footer:', error);
        });
}


window.onload = loadFooter;
