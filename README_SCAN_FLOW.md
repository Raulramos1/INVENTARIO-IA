# Flujo de escaneo con Barcode Buddy

- [ ] Arranca Barcode Buddy con `OVERRIDDEN_USER_CONFIG`, asegurando que
      `GROCY_API_URL` termine en `/api/` y que `GROCY_API_KEY` sea válida.
- [ ] En la web de Barcode Buddy, ve a **API → Add mobile app** y escanea
      el QR desde la app oficial de Android para emparejar.
- [ ] Realiza un escaneo en modo **Purchase** para dar de alta productos
      en Grocy.
- [ ] Observa los cambios en Home Assistant: vistas Lovelace relacionadas
      y el botón "Refrescar" (automatización actualiza cada 2 min).
- [ ] Si algo falla, revisa los logs de Barcode Buddy, los logs de Home
      Assistant, la validez de la API key o la URL de Grocy.
