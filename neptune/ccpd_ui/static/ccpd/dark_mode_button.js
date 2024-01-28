/* 
Author: Alejandro Valencia
Update: December 18, 2023 
*/


document.getElementById('DarkModeSwitchCheckDefault').addEventListener('click', () => {
  if (document.documentElement.getAttribute('data-bs-theme') == 'dark') {
    document.documentElement.setAttribute('data-bs-theme', 'light')
  }
  else {
    document.documentElement.setAttribute('data-bs-theme', 'dark')
  }
})

document.getElementById('FillExampleValuesBtn').addEventListener('click', () => {
  var design_input_form = document.getElementById('DesignInputs')
  console.log(design_input_form.getAttributeNames)
  // design_input_form.getElementById('MassFlowRate').value = "90"
})
