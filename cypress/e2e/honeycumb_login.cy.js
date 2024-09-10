describe('template spec', () => {
  it('passes', () => {
    cy.visit('http://127.0.0.1:3333')
  })
})


// Login exitoso

describe('Login Test', () => {
  it('should login successfully with valid credentials', () => {
    cy.visit('http://127.0.0.1:3333/login.html'); // Navega a la página de login
    cy.get('input[name="email"]').type('validUser'); // Ingresa el nombre de usuario
    cy.get('input[name="password"]').type('validPassword'); // Ingresa la contraseña
    cy.get('button[name="submit"]').click(); // Hace clic en el botón de login
    cy.url().should('include', '/dashboard'); // Verifica que redirige al dashboard
  });
});

// Login fallido (credenciales incorrectas)

it('should show error with invalid credentials', () => {
  cy.visit('http://127.0.0.1:3333/login.html');
  cy.get('input[name="email"]').type('invalidUser');
  cy.get('input[name="password"]').type('invalidPassword');
  cy.get('button[name="submit"]').click();
  cy.get('.error-message').should('be.visible') // Verifica que el mensaje de error aparece
    .and('contain', 'Usuario o contraseña incorrectos');
});

// Campos obligatorios

it('should require both username and password', () => {
  cy.visit('http://127.0.0.1:3333/login.html');
  cy.get('button[name="submit"]').click(); // Intenta iniciar sesión sin ingresar credenciales
  cy.get('.error-message').should('contain', 'Campo requerido'); // Verifica mensajes de error
});

// Bloqueo de cuenta después de intentos fallidos

it('should block account after several failed attempts', () => {
  cy.visit('http://127.0.0.1:3333/login.html');
  for (let i = 0; i < 5; i++) {
    cy.get('input[name="email"]').type('validUser');
    cy.get('input[name="password"]').type('wrongPassword');
    cy.get('button[name="submit"]').click();
  }
  cy.get('.error-message').should('contain', 'Cuenta bloqueada');
});


// SQL Injection


it('should not allow SQL Injection', () => {
  cy.visit('http://127.0.0.1:3333/login.html');
  cy.get('input[name="email"]').type("admin' OR 1=1 --");
  cy.get('input[name="password"]').type('anyPassword');
  cy.get('button[name="submit"]').click();
  cy.url().should('not.include', '/dashboard'); // No debe permitir el acceso
});

// Fuerza bruta

it('should prevent brute force attacks', () => {
  cy.visit('http://127.0.0.1:3333/login.html');
  for (let i = 0; i < 100; i++) {  // Intentar múltiples veces
    cy.get('input[name="email"]').type('validUser');
    cy.get('input[name="password"]').type(`invalidPassword${i}`);
    cy.get('button[name="submit"]').click();
  }
  cy.get('.error-message').should('contain', 'Cuenta bloqueada');
});

// Mensajes de error claros

it('should display a user-friendly error message', () => {
  cy.visit('http://127.0.0.1:3333/login.html');
  cy.get('input[name="email"]').type('invalidUser');
  cy.get('input[name="password"]').type('invalidPassword');
  cy.get('button[name="submit"]').click();
  cy.get('.error-message').should('be.visible')
    .and('contain', 'Usuario o contraseña incorrectos');
});

// Recuperación de contraseña

it('should allow password recovery', () => {
  cy.visit('http://127.0.0.1:3333/login.html');
  cy.get('a[href="/forgot-password"]').click(); // Hace clic en el enlace de recuperación
  cy.url().should('include', '/forgot-password');
  cy.get('input[name="email"]').type('user@example.com');
  cy.get('button[name="submit"]').click();
  cy.get('.success-message').should('contain', 'Correo de recuperación enviado');
});



// Tiempo de respuesta

it('should respond in a reasonable time', () => {
  cy.request({
    method: 'POST',
    url: '/api/login',
    body: { username: 'validUser', password: 'validPassword' }
  }).then((response) => {
    expect(response.duration).to.be.lessThan(1000); // El tiempo de respuesta debe ser menor a 1 segundo
  });
});



