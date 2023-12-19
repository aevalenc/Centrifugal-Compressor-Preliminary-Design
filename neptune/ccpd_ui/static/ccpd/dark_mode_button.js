/* 
Author: Alejandro Valencia
Update: December 18, 2023 
*/


document.getElementById('dark_mode_btn_switch').addEventListener('click', () => {
  if (document.documentElement.getAttribute('data-bs-theme') == 'dark') {
    document.documentElement.setAttribute('data-bs-theme', 'light')
  }
  else {
    document.documentElement.setAttribute('data-bs-theme', 'dark')
  }
})
