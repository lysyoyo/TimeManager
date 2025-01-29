// cypress/integration/admin_layout_spec.js

describe('Admin Layout', () => {
  beforeEach(() => {
    // Assuming your admin page is at '/admin'
    cy.visit('/admin');
  });

  it('displays the correct site name', () => {
    cy.get('.site-name').should('contain', 'BATMAN - Admin');
  });

  it('has the correct number of menu items', () => {
    cy.get('.menu-list .menu-item').should('have.length', 5); // 4 menu items + logout
  });

  it('highlights the active menu item', () => {
    cy.get('.menu-item').first().should('have.class', 'active');
  });

  it('navigates to the correct route when a menu item is clicked', () => {
    cy.get('.menu-item').contains('Profile').click();
    cy.url().should('include', '/admin/profile');
  });

  it('logs out when the logout button is clicked', () => {
    cy.get('[data-cy="logout"]').should('exist');
  });
});