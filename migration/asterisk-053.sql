/*
 * XiVO Base-Config
 * Copyright (C) 2012-2014  Avencall
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

BEGIN;

DROP FUNCTION IF EXISTS "fill_saturated_calls" (text, text);
CREATE FUNCTION "fill_saturated_calls"(period_start text, period_end text)
  RETURNS void AS
$$
  -- Insert full, divert_ca_ratio, divert_waittime into stat_call_on_queue
  INSERT INTO "stat_call_on_queue" (callid, "time", queue_id, status)
    SELECT
      callid,
      CAST ("time" AS TIMESTAMP) as "time",
      (SELECT id FROM stat_queue WHERE name=queuename) as queue_id,
      CASE WHEN event = 'FULL' THEN 'full'::call_exit_type
           WHEN event = 'DIVERT_CA_RATIO' THEN 'divert_ca_ratio'
           WHEN event = 'DIVERT_HOLDTIME' THEN 'divert_waittime'
      END as status
    FROM queue_log
    WHERE event = 'FULL' OR event LIKE 'DIVERT_%' AND
          "time" BETWEEN $1 AND $2;
$$
LANGUAGE SQL;

COMMIT;