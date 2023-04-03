
int modoScanner = 0;

String codiBarresSeleccionat = '';
TractametCodiBarresSeleccionat tractametCodiBarresSeleccionat = TractametCodiBarresSeleccionat.llegirProducte;

enum TractametCodiBarresSeleccionat {
  cap,
  llegirProducte,
  llegirDocument,

}

enum AccioBarresSeleccionat {
  cap,
  llegitCodi,
  intentLectura,

}

String codiBarresLLegit(AccioBarresSeleccionat accioBarresSeleccionat, String codi) {
  String s = codi;
  switch (tractametCodiBarresSeleccionat) {
    case TractametCodiBarresSeleccionat.cap:
      break;
    case TractametCodiBarresSeleccionat.llegirProducte:
      switch (accioBarresSeleccionat){
        case AccioBarresSeleccionat.cap:
          break;
        case AccioBarresSeleccionat.llegitCodi:
          // todo: llegir el codi a la taula de productes
          s = 'Codi trobat: $codi';
          codiBarresSeleccionat = codi;
          break;
        default:
          break;
      }
      break;
    case TractametCodiBarresSeleccionat.llegirDocument:

      // todo: llegir el codi a la taula de documents

      break;
    default:
      break;
  }

  return s;
}