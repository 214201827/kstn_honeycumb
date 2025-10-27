

// Datos de entrada
const studentInfo = {
    lastName: "Last Names",
    firstName: "Names",
    email: "student@students.keystone.edu.mx",
    courseName: "Desarrollo Emocional - 1st A -",
    professorName: "Professor Last Name",
    professorEmail: "professor@keystone.edu.mx",
    overallGrade: "99.5%"
};

const assignments = [
    { date: "2023-09-18", title: "Derechos y obligaciones de los niños", mark: "10/10", percent: "100%", status: "Completed" },
    { date: "2023-09-21", title: "Derecho y obligaciones de los niños (sesión 2)", mark: "10/10", percent: "100%", status: "Completed" },
    { date: "2023-09-25", title: "Comentarios positivos/ respeto sobre su cuerpo", mark: "10/10", percent: "100%", status: "Completed" },
    // Agrega más tareas aquí según sea necesario...
];

const comentario = "Fino, señores";

// Función para generar el reporte
function generateReport() {
    const container = document.getElementById("report-container");

    // Construir el HTML del reporte
    let reportHtml = `
    <div>
        <img src="images/text-keystone.png" style="float: left; width: auto; height: 50px; filter: invert(100%); padding-right: 20px">
        <h2 style="padding: 10px;">${studentInfo.courseName}</h2>
    </div>
        
    <p><strong>Student:</strong> ${studentInfo.lastName}, ${studentInfo.firstName} (${studentInfo.email})</p>
    <p><strong>Professor:</strong> ${studentInfo.professorName} (${studentInfo.professorEmail})</p>
    <p><strong>Overall Grade:</strong> ${studentInfo.overallGrade}</p>
    
    <hr>
    <table border="1" cellspacing="0" cellpadding="8">
    <thead>
    <tr>
    <th>Date</th>
    <th>Assignment</th>
    <th>Mark</th>
    <th>Percent</th>
    <th>Status</th>
    </tr>
    </thead>
            <tbody>
    `;

    // Agregar cada tarea en una fila de la tabla
    assignments.forEach(assignment => {
        reportHtml += `
            <tr>
                <td>${assignment.date}</td>
                <td>${assignment.title}</td>
                <td>${assignment.mark}</td>
                <td>${assignment.percent}</td>
                <td>${assignment.status}</td>
            </tr>
        `;
    });

    reportHtml += `
            </tbody>
        </table>


        <table border="1" cellspacing="0" cellpadding="8">
            <tr>
                <th>Comentario</th>
            </tr>
            <tbody>
            <tr>
                <td>${comentario}</td>
            </tr>
            </tbody>

        </table>


    `;

    

    // Insertar el HTML en el contenedor
    container.innerHTML = reportHtml;
    console.log(reportHtml);
}

// Ejecutar la función al cargar la página
window.onload = generateReport;
