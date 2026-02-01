// Load the navbar HTML file
fetch("header.html")
  .then(response => response.text())
  .then(data => {
    document.getElementById("navbarContainer").innerHTML = data;

    // Highlight the current page by adding 'active' class to the correct link
    let currentPage = window.location.pathname.split("/").pop();
    currentPage = currentPage.replace('.html', '');

    document.querySelectorAll('.navbar-nav .nav-link').forEach(link => {
      if (link.getAttribute('href').includes(currentPage)) {
        link.classList.add('active');
      }
    });
  })
  .catch(error => console.error('Error loading the navbar:', error));
