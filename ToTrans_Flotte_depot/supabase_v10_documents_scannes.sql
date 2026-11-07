-- ToTrans Flotte v10 : documents scannés des camions, des chauffeurs et des documents administratifs
-- À exécuter UNE fois dans Supabase > SQL Editor > New query > Run, AVANT de déposer la v10.
-- Les fichiers restent dans le stockage privé "justificatifs", rangés par module : <module>/<id>/<fichier>.
-- Chacun peut voir / ajouter les fichiers des modules qu'il peut lire / modifier (droits de la page Utilisateurs).

drop policy if exists "justificatifs lecture" on storage.objects;
create policy "justificatifs lecture" on storage.objects for select to authenticated
  using (bucket_id = 'justificatifs'
         and (storage.foldername(name))[1] in ('achats','vehicules','chauffeurs','documents')
         and public.peut_lire((storage.foldername(name))[1]));

drop policy if exists "justificatifs ajout" on storage.objects;
create policy "justificatifs ajout" on storage.objects for insert to authenticated
  with check (bucket_id = 'justificatifs'
              and (storage.foldername(name))[1] in ('achats','vehicules','chauffeurs','documents')
              and public.peut_ecrire((storage.foldername(name))[1]));

-- Retirer un scan (camions, chauffeurs, documents seulement : les pièces des demandes d'achat restent)
drop policy if exists "justificatifs suppression" on storage.objects;
create policy "justificatifs suppression" on storage.objects for delete to authenticated
  using (bucket_id = 'justificatifs'
         and (storage.foldername(name))[1] in ('vehicules','chauffeurs','documents')
         and public.peut_ecrire((storage.foldername(name))[1]));
