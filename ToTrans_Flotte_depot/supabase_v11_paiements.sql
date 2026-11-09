-- ToTrans Flotte v11 : copies scannées des chèques / paiements
-- À exécuter UNE fois dans Supabase > SQL Editor > New query > Run, AVANT de déposer la v11.
-- Ajoute le dossier "paiements" aux règles du stockage privé "justificatifs".

drop policy if exists "justificatifs lecture" on storage.objects;
create policy "justificatifs lecture" on storage.objects for select to authenticated
  using (bucket_id = 'justificatifs'
         and (storage.foldername(name))[1] in ('achats','vehicules','chauffeurs','documents','paiements')
         and public.peut_lire((storage.foldername(name))[1]));

drop policy if exists "justificatifs ajout" on storage.objects;
create policy "justificatifs ajout" on storage.objects for insert to authenticated
  with check (bucket_id = 'justificatifs'
              and (storage.foldername(name))[1] in ('achats','vehicules','chauffeurs','documents','paiements')
              and public.peut_ecrire((storage.foldername(name))[1]));

drop policy if exists "justificatifs suppression" on storage.objects;
create policy "justificatifs suppression" on storage.objects for delete to authenticated
  using (bucket_id = 'justificatifs'
         and (storage.foldername(name))[1] in ('vehicules','chauffeurs','documents','paiements')
         and public.peut_ecrire((storage.foldername(name))[1]));
