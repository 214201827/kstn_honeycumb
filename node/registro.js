document.addEventListener('DOMContentLoaded', function() {
    // Escucha el evento submit del formulario
    const form = document.getElementById("registroForm");
    
    form.addEventListener('submit', async function(event) {
        event.preventDefault(); // Evita que el formulario recargue la página

        // Obtén los valores de los inputs
        const nombre = document.getElementById("nombre").value;
        const email = document.getElementById("email").value;
        const password = document.getElementById("password").value;

        console.log( nombre, email, password );

        

        // Datos que quieres enviar en la petición POST
        const data = {
            nombre: nombre,
            email: email,
            password: password
        };

        try {
            const response = await fetch('http://localhost:3000/regUsr', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json' // Indica que se envía JSON
                },
                body: JSON.stringify(data) // Convierte los datos a JSON antes de enviarlos
            });

            const responseData = await response.json();
            console.log('Respuesta del servidor:', responseData);
        } catch (error) {
            console.error('Error en la petición:', error);
        }
            
    });
});
