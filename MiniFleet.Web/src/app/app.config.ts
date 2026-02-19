import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';
import { provideHttpClient } from '@angular/common/http'; 

export const appConfig: ApplicationConfig = {
  // Ajout de provideHttpClient() dans les providers
  providers: [provideRouter(routes), provideHttpClient()]
};